local M = {}

local NAME = "CursorAnimation"
local ns = vim.api.nvim_create_namespace(NAME)
local uv = vim.uv or vim.loop

---@class cursor_animation.Config
---@field min_lines integer Minimum vertical distance that triggers the animation
---@field max_steps integer Upper bound on interpolation steps
---@field hl_group string Highlight group used for the overlay
---@field scroll_grace_ms integer Ignore cursor moves this soon after a scroll
---@field animate table Options forwarded to `Snacks.animate`
---@type cursor_animation.Config
local defaults = {
  min_lines = 2,
  max_steps = 1000,
  hl_group = "CursorAnimation",
  scroll_grace_ms = 100,
  animate = {
    duration = { step = 25, total = 400 },
    easing = "linear",
  },
}

---@class cursor_animation.Position
---@field buf integer
---@field win integer
---@field line integer
---@field virtcol integer
---@field topline integer

---@class cursor_animation.Overlay
---@field buf integer
---@field win integer
---@field line integer
---@field col integer

---@class cursor_animation.State
---@field last_pos? cursor_animation.Position
---@field overlay? cursor_animation.Overlay
---@field last_scroll_at integer

---@type cursor_animation.Config
local config = vim.deepcopy(defaults)

---@type cursor_animation.State
local state = { last_scroll_at = 0 }

---@return cursor_animation.Position
local function get_position()
  local view = vim.fn.winsaveview()
  return {
    buf = vim.api.nvim_get_current_buf(),
    win = vim.api.nvim_get_current_win(),
    line = view.lnum,
    virtcol = vim.fn.virtcol("."),
    topline = view.topline,
  }
end

---@param win? integer
local function redraw_window(win)
  if win and vim.api.nvim_win_is_valid(win) then
    pcall(vim.api.nvim__redraw, { win = win, valid = false })
  end
end

local function clear_overlay()
  local win = state.overlay and state.overlay.win
  state.overlay = nil
  redraw_window(win)
end

local function cancel_animation()
  Snacks.animate.del(NAME)
  clear_overlay()
end

---@param win integer
---@param line integer
---@return { leftcol: integer, folded: boolean, text_width: integer }
local function get_window_metrics(win, line)
  return vim.api.nvim_win_call(win, function()
    local info = vim.fn.getwininfo(win)[1]
    return {
      leftcol = vim.fn.winsaveview().leftcol,
      folded = vim.fn.foldclosed(line) ~= -1,
      text_width = info.width - info.textoff,
    }
  end)
end

---@param buf integer
---@param win integer
---@param line integer
---@param virtcol integer
local function render_overlay(buf, win, line, virtcol)
  if
    not vim.api.nvim_win_is_valid(win)
    or vim.api.nvim_win_get_buf(win) ~= buf
    or line < 1
    or line > vim.api.nvim_buf_line_count(buf)
  then
    clear_overlay()
    return
  end

  local metrics = get_window_metrics(win, line)
  local col = virtcol - metrics.leftcol
  if metrics.folded or col < 1 or col > metrics.text_width then
    clear_overlay()
    return
  end

  state.overlay = { buf = buf, win = win, line = line, col = col }
  redraw_window(win)
end

---@param buf integer
---@return boolean
local function is_eligible(buf)
  return vim.bo[buf].buftype == ""
    and vim.api.nvim_win_get_config(0).relative == ""
    and vim.fn.reg_executing() == ""
    and (uv.hrtime() - state.last_scroll_at) / 1e6 > config.scroll_grace_ms
    and Snacks.animate.enabled({ buf = buf, name = "cursor" })
end

local function on_cursor_moved()
  local from, to = state.last_pos, get_position()
  state.last_pos = to

  if not from or from.buf ~= to.buf or from.win ~= to.win then
    cancel_animation()
    return
  end
  if from.topline ~= to.topline or not is_eligible(to.buf) then
    cancel_animation()
    return
  end

  local d_line = to.line - from.line
  local d_col = to.virtcol - from.virtcol
  if math.abs(d_line) < config.min_lines then
    cancel_animation()
    return
  end

  local steps = math.min(math.max(math.abs(d_line), math.abs(d_col)), config.max_steps)
  local opts = vim.tbl_extend("force", vim.deepcopy(config.animate), {
    int = true,
    id = NAME,
    buf = to.buf,
  })

  Snacks.animate(0, steps, function(value, ctx)
    if ctx.done or vim.api.nvim_get_current_buf() ~= to.buf then
      clear_overlay()
      return
    end
    local progress = value / steps
    render_overlay(
      to.buf,
      to.win,
      math.floor(from.line + d_line * progress + 0.5),
      math.floor(from.virtcol + d_col * progress + 0.5)
    )
  end, opts)
end

local function setup_highlight()
  vim.api.nvim_set_hl(0, config.hl_group, { default = true, reverse = true, nocombine = true })
end

---@class cursor_animation.Opts
---@field min_lines? integer
---@field max_steps? integer
---@field hl_group? string
---@field scroll_grace_ms? integer
---@field animate? table

---@param opts? cursor_animation.Opts
function M.setup(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
  setup_highlight()

  vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, win, buf)
      local overlay = state.overlay
      return overlay ~= nil and overlay.win == win and overlay.buf == buf
    end,
    on_line = function(_, _, buf, row)
      local overlay = state.overlay
      if overlay and row == overlay.line - 1 then
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
          ephemeral = true,
          hl_mode = "combine",
          priority = 1000,
          virt_text = { { " ", config.hl_group } },
          virt_text_win_col = overlay.col - 1,
          virt_text_pos = "overlay",
        })
      end
    end,
  })

  local group = vim.api.nvim_create_augroup(NAME, { clear = true })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    callback = on_cursor_moved,
  })
  vim.api.nvim_create_autocmd("WinScrolled", {
    group = group,
    callback = function()
      state.last_scroll_at = uv.hrtime()
    end,
  })
  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "InsertEnter" }, {
    group = group,
    callback = cancel_animation,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = setup_highlight,
  })
end

return M
