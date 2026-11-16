local M = {}

local ID = "cursor_path"
local ns = vim.api.nvim_create_namespace(ID)
local uv = vim.uv or vim.loop

---@class bugs.cursor_animate.Config
local defaults = {
  min_lines = 2,
  max_steps = 1000,
  hl = "CursorAnimate",
  scroll_grace = 100,
  animate = {
    duration = { step = 25, total = 400 },
    easing = "linear",
  },
}

local config = defaults
local prev ---@type {buf:number, win:number, line:number, virtcol:number, topline:number}?
local last_scroll = 0

local function snapshot()
  local view = vim.fn.winsaveview()
  return {
    buf = vim.api.nvim_get_current_buf(),
    win = vim.api.nvim_get_current_win(),
    line = view.lnum,
    virtcol = vim.fn.virtcol("."),
    topline = view.topline,
  }
end

local function clear(buf)
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  end
end

local function stop()
  Snacks.animate.del(ID)
  clear(prev and prev.buf)
end

local function draw(buf, win, line, virtcol)
  clear(buf)
  if line < 1 or line > vim.api.nvim_buf_line_count(buf) then
    return
  end
  local leftcol = vim.api.nvim_win_call(win, function()
    return vim.fn.winsaveview().leftcol
  end)
  local col = virtcol - leftcol
  if col < 1 then
    return
  end
  pcall(vim.api.nvim_buf_set_extmark, buf, ns, line - 1, 0, {
    hl_mode = "combine",
    priority = 1000,
    right_gravity = false,
    virt_text = { { " ", config.hl } },
    virt_text_win_col = col - 1,
    virt_text_pos = "overlay",
  })
end

local function eligible(buf)
  return vim.bo[buf].buftype == ""
    and vim.api.nvim_win_get_config(0).relative == ""
    and vim.fn.reg_executing() == ""
    and (uv.hrtime() - last_scroll) / 1e6 > config.scroll_grace
    and Snacks.animate.enabled({ buf = buf, name = "cursor" })
end

local function on_move()
  local from, to = prev, snapshot()
  prev = to

  if not from or from.buf ~= to.buf or from.win ~= to.win then
    stop()
    return
  end
  if from.topline ~= to.topline or not eligible(to.buf) then
    stop()
    return
  end

  local dl, dc = to.line - from.line, to.virtcol - from.virtcol
  if math.abs(dl) < config.min_lines then
    return
  end

  local n = math.min(math.max(math.abs(dl), math.abs(dc)), config.max_steps)
  local opts = vim.tbl_extend("force", vim.deepcopy(config.animate), { int = true, id = ID, buf = to.buf })

  Snacks.animate(0, n, function(value, ctx)
    if ctx.done or vim.api.nvim_get_current_buf() ~= to.buf then
      clear(to.buf)
      return
    end
    local f = value / n
    draw(to.buf, to.win, math.floor(from.line + dl * f + 0.5), math.floor(from.virtcol + dc * f + 0.5))
  end, opts)
end

local function set_hl()
  vim.api.nvim_set_hl(0, config.hl, { default = true, reverse = true, nocombine = true })
end

---@param opts? bugs.cursor_animate.Config
function M.setup(opts)
  config = vim.tbl_deep_extend("force", defaults, opts or {})
  set_hl()

  local group = vim.api.nvim_create_augroup(ID, { clear = true })
  vim.api.nvim_create_autocmd("CursorMoved", { group = group, callback = on_move })
  vim.api.nvim_create_autocmd("WinScrolled", {
    group = group,
    callback = function()
      last_scroll = uv.hrtime()
    end,
  })
  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "InsertEnter" }, { group = group, callback = stop })
  vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_hl })
end

return M
