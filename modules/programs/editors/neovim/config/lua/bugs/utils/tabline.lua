local M = {}

-- Internals live in H; the public surface is M.setup, M.render and M.pick.
local H = {}

-- Separators
H.sep_left = ""
H.sep_right = ""
H.sep_start = ""
H.sep_end = ""

H.max_name_length = 20
H.truncate_to = 17

-- Pick letters, in order of preference
H.alphabet = "asdfghjklqwertyuiopzxcvbnm"
H.picking = false
H.labels = {} -- tabnr -> letter, filled only while picking

---@param filename string
---@return string icon, string hl
function H.get_icon(filename)
  if MiniIcons and MiniIcons.get then
    return MiniIcons.get("file", filename)
  end
  return "", "Normal" -- restore fallback glyph
end

---@param bufnr number
---@return string name, string icon
function H.get_buf_info(bufnr)
  if vim.bo[bufnr].buftype == "terminal" then
    return "[Terminal]", "" -- restore terminal glyph
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
    return "[No Name]", ""
  end

  local filename = vim.fn.fnamemodify(bufname, ":t")
  local icon = H.get_icon(filename)

  if #filename > H.max_name_length then
    filename = filename:sub(1, H.truncate_to) .. "…"
  end
  return filename, icon
end

---Buffer in a tab's active window.
---@param tabnr number
---@return number?
function H.tab_bufnr(tabnr)
  local buflist = vim.fn.tabpagebuflist(tabnr)
  if type(buflist) ~= "table" then
    return nil
  end
  return buflist[vim.fn.tabpagewinnr(tabnr)]
end

---Text a tab's pick letter is derived from ("" for terminals and unnamed buffers).
---@param bufnr number
---@return string
function H.label_source(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return ""
  end
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
end

---First free letter from the name itself, else from the alphabet.
---@param name string
---@param used table<string, number>
---@return string?
function H.pick_letter(name, used)
  for char in name:lower():gmatch("%w") do
    if H.alphabet:find(char, 1, true) and not used[char] then
      return char
    end
  end
  for char in H.alphabet:gmatch(".") do
    if not used[char] then
      return char
    end
  end
end

---Assign a letter to every tab, left to right.
---@return table<number, string> by_tab, table<string, number> by_letter
function H.assign_labels()
  local by_tab, by_letter = {}, {}
  for tabnr = 1, vim.fn.tabpagenr("$") do
    local bufnr = H.tab_bufnr(tabnr)
    local letter = H.pick_letter(bufnr and H.label_source(bufnr) or "", by_letter)
    if letter then
      by_tab[tabnr] = letter
      by_letter[letter] = tabnr
    end
  end
  return by_tab, by_letter
end

---@param tabnr number
---@param is_active boolean
---@param is_first boolean
---@param is_last boolean
---@return string
function H.render_tab(tabnr, is_active, is_first, is_last)
  local bufnr = H.tab_bufnr(tabnr)
  if not bufnr then
    return ""
  end

  local filename, icon = H.get_buf_info(bufnr)
  local name = filename:gsub("%%", "%%%%") -- '%' is special in tabline strings

  local tab_hl = is_active and "%#TabLineActive#" or "%#TabLineInactive#"
  local sep_hl = is_active and "%#TabLineSepActive#" or "%#TabLineSepInactive#"

  -- While picking, the letter replaces the icon (padded to the icon's width).
  local marker = icon
  local letter = H.picking and H.labels[tabnr]
  if letter then
    local pick_hl = is_active and "%#TabLinePickActiveLabel#" or "%#TabLinePickInactiveLabel#"
    local pad = string.rep(" ", math.max(vim.api.nvim_strwidth(icon) - 1, 0))
    marker = pick_hl .. letter .. pad .. tab_hl
  end

  local modified = vim.bo[bufnr].modified and "[+] " or ""
  local title = "   " .. modified .. marker .. " " .. name .. "   "

  local left_sep = is_first and H.sep_start or H.sep_left
  local right_sep = is_last and H.sep_end or H.sep_right

  return string.format("%%%dT%s%s%s%s%s%s%%T", tabnr, sep_hl, left_sep, tab_hl, title, sep_hl, right_sep)
end

---@return string
function M.render()
  local ok, result = pcall(function()
    local parts = {}
    local current = vim.fn.tabpagenr()
    local count = vim.fn.tabpagenr("$")

    for tabnr = 1, count do
      parts[#parts + 1] = H.render_tab(tabnr, tabnr == current, tabnr == 1, tabnr == count)
    end
    return table.concat(parts) .. "%#TabLineFill#"
  end)

  return ok and result or "%#TabLineFill#"
end

---Label every tab, wait for one key, then call `on_pick(tabnr)` for the match.
---Any other key (or Ctrl-C) cancels.
---@param on_pick? fun(tabnr: number) defaults to jumping to the tab
function M.pick(on_pick)
  if vim.fn.tabpagenr("$") < 2 then
    return
  end
  on_pick = on_pick or function(tabnr)
    vim.cmd(tabnr .. "tabnext")
  end

  local by_tab, by_letter = H.assign_labels()
  H.labels, H.picking = by_tab, true
  vim.cmd.redrawtabline()
  vim.cmd.redraw() -- getcharstr() blocks, so repaint first

  local ok, char = pcall(vim.fn.getcharstr) -- Ctrl-C throws

  H.picking, H.labels = false, {}
  vim.cmd.redrawtabline()

  if not ok then
    return
  end
  local tabnr = by_letter[char:lower()]
  if tabnr then
    on_pick(tabnr)
  end
end

---@param opts? { showtabline: integer }
function M.setup(opts)
  opts = opts or {}

  vim.o.tabline = "%!v:lua.require('bugs.utils.tabline').render()"
  vim.o.showtabline = opts.showtabline or 1

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufModifiedSet", "TabEnter", "TabNew", "TabClosed" }, {
    group = vim.api.nvim_create_augroup("CustomTabline", { clear = true }),
    callback = function()
      vim.cmd.redrawtabline()
    end,
  })
end

return M
