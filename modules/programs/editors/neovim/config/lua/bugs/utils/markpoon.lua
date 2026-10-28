local M = {}

-- Constants
local ns = vim.api.nvim_create_namespace("markpoon")

local MAX_TEXT_WIDTH = 60
local SIDE_PADDING = 2

--- @diagnostic disable-next-line: undefined-doc-name
--- @type snacks.win?
local current

--- Collect buffer-local (a-z) marks with their trimmed line text.
--- @return table[] marks, integer bufnr
local function get_marks()
  local bufnr = vim.fn.bufnr("%")
  local marks = vim.fn.getmarklist(bufnr)
  local result = {}
  for _, mk in ipairs(marks) do
    local name = mk.mark:sub(2)
    if name:match("^[a-z]$") then
      local line = mk.pos[2]
      local col = mk.pos[3] - 1
      local raw = vim.fn.getbufline(bufnr, line)[1] or ""
      local text = vim.trim(raw)
      local truncated = false
      if #text > MAX_TEXT_WIDTH then
        text = text:sub(1, MAX_TEXT_WIDTH)
        truncated = true
      end
      table.insert(result, {
        mark = name,
        line = line,
        col = col,
        text = text,
        truncated = truncated,
      })
    end
  end
  table.sort(result, function(a, b)
    return a.mark < b.mark
  end)
  return result, bufnr
end

--- @param m table mark entry
--- @return string
local function gutter_string(m)
  return string.format("%s  %4d  ", m.mark, m.line)
end

--- Build the gutter's virt_text chunks for one row.
--- @param m table mark entry
--- @param gutter_width integer
--- @param pad integer left margin width
--- @param is_cursor boolean whether this row is the active row
--- @return table[]
local function gutter_virt_text(m, gutter_width, pad, is_cursor)
  local gutter = gutter_string(m)
  local gutter_pad = string.rep(" ", gutter_width - #gutter)

  local mark_hl = is_cursor and "MarkpoonLineNrCursor" or "MarkpoonMark"
  local linenr_hl = is_cursor and "MarkpoonLineNrCursor" or "MarkpoonLineNr"

  local chunks = {}
  if pad > 0 then
    table.insert(chunks, { string.rep(" ", pad), "NormalFloat" })
  end
  vim.list_extend(chunks, {
    { m.mark, mark_hl },
    { "  ", "NormalFloat" },
    { string.format("%4d", m.line), linenr_hl },
    { "  " .. gutter_pad, "NormalFloat" },
  })
  return chunks
end

--- Render the mark list into ctx.buf, updating ctx's width/id fields in place.
--- @param ctx table popup context
local function render(ctx)
  local lines = {}
  local content_width = 0
  local gutter_width = 0

  for _, m in ipairs(ctx.marks) do
    local line = m.text .. (m.truncated and "..." or "")
    content_width = math.max(content_width, #line)
    gutter_width = math.max(gutter_width, #gutter_string(m))
    table.insert(lines, line)
  end

  vim.bo[ctx.buf].modifiable = true
  vim.api.nvim_buf_clear_namespace(ctx.buf, ns, 0, -1)
  vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, lines)
  vim.bo[ctx.buf].modifiable = false

  local gutter_ids = {}
  for row0, m in ipairs(ctx.marks) do
    local row = row0 - 1
    gutter_ids[row0] = vim.api.nvim_buf_set_extmark(ctx.buf, ns, row, 0, {
      virt_text = gutter_virt_text(m, gutter_width, SIDE_PADDING, false),
      virt_text_pos = "inline",
    })
  end

  ctx.gutter_width = gutter_width
  ctx.content_width = content_width
  ctx.gutter_ids = gutter_ids
end

--- @param ctx table popup context
--- @param row integer
--- @param is_cursor boolean
local function set_row_cursor(ctx, row, is_cursor)
  local m = ctx.marks[row]
  local id = ctx.gutter_ids[row]
  if not m or not id then
    return
  end
  vim.api.nvim_buf_set_extmark(ctx.buf, ns, row - 1, 0, {
    id = id,
    virt_text = gutter_virt_text(m, ctx.gutter_width, SIDE_PADDING, is_cursor),
    virt_text_pos = "inline",
  })
end

--- @param ctx table popup context
local function update_cursor_highlight(ctx)
  local row = vim.api.nvim_win_get_cursor(ctx.win.win)[1]
  if row == ctx.active_row then
    return
  end
  if ctx.active_row then
    set_row_cursor(ctx, ctx.active_row, false)
  end
  set_row_cursor(ctx, row, true)
  ctx.active_row = row
end

--- @param ctx table popup context
--- @param row integer
local function jump_to_mark(ctx, row)
  local m = ctx.marks[row]
  if not m then
    return
  end
  ctx.win:close()
  if vim.api.nvim_win_is_valid(ctx.src_win) then
    vim.api.nvim_set_current_win(ctx.src_win)
  end
  vim.api.nvim_win_set_cursor(ctx.src_win, { m.line, m.col })
end

--- @param ctx table popup context
local function resize_to_content(ctx)
  ctx.win.opts.width = ctx.gutter_width + SIDE_PADDING + ctx.content_width + SIDE_PADDING
  ctx.win.opts.height = #ctx.marks
  ctx.win:update()
end

--- @param ctx table popup context
local function delete_current_mark(ctx)
  local row = vim.api.nvim_win_get_cursor(ctx.win.win)[1]
  local m = ctx.marks[row]
  if not m then
    return
  end

  vim.api.nvim_buf_del_mark(ctx.src_bufnr, m.mark)
  table.remove(ctx.marks, row)

  if vim.api.nvim_win_is_valid(ctx.src_win) then
    local ok = pcall(vim.api.nvim__redraw, { win = ctx.src_win, valid = false, flush = true })
    if not ok then
      vim.cmd("redraw")
    end
  end

  if #ctx.marks == 0 then
    ctx.win:close()
    return
  end

  render(ctx)
  ctx.active_row = nil
  resize_to_content(ctx)

  vim.api.nvim_win_set_cursor(ctx.win.win, { math.min(row, #ctx.marks), 0 })
  update_cursor_highlight(ctx)
end

--- Open the Markpoon mark-list popup for the current buffer.
local function open_window()
  local marks, src_bufnr = get_marks()
  local src_win = vim.api.nvim_get_current_win()

  if #marks == 0 then
    vim.notify("No buffer local marks is set", vim.log.levels.INFO, { title = "Makrpoon" })
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false

  local ctx = {
    buf = buf,
    marks = marks,
    src_win = src_win,
    src_bufnr = src_bufnr,
    active_row = nil,
  }

  render(ctx)

  local width = ctx.gutter_width + SIDE_PADDING + ctx.content_width + SIDE_PADDING
  local height = #ctx.marks

  local win = Snacks.win.new({
    style = "float",
    buf = buf,
    enter = true,
    width = width,
    height = height,
    border = "rounded",
    title = " Makrpoon ",
    title_pos = "center",
    backdrop = 40,
    keys = {
      q = "close",
      ["<Esc>"] = "close",
      ["<CR>"] = function(self)
        jump_to_mark(ctx, vim.api.nvim_win_get_cursor(self.win)[1])
      end,
      dd = function()
        delete_current_mark(ctx)
      end,
    },
    on_win = function(self)
      ctx.win = self
      update_cursor_highlight(ctx)
      self:on("CursorMoved", function()
        update_cursor_highlight(ctx)
      end, { buf = true })
    end,
    on_close = function()
      if current == ctx.win then
        current = nil
      end
    end,
  })

  ctx.win = win
  current = win
end

--- Toggle the Markpoon popup: close it if open, otherwise open a fresh one.
function M.toggle()
  ---@diagnostic disable-next-line: undefined-field
  if current and current:valid() then
    ---@diagnostic disable-next-line: undefined-field
    current:close()
    return
  end
  open_window()
end

return M
