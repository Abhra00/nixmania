---@class utils.editor
local M = {}

local root = require("bugs.utils.root")

---Filetypes whose markdown fence language differs from the filetype name.
local fence_languages = {
  javascript = "js",
  javascriptreact = "jsx",
  typescript = "ts",
  typescriptreact = "tsx",
}

---Copy `text` to the system clipboard and notify about it.
---@param text string
---@param message string
local function copy(text, message)
  vim.fn.setreg("+", text)
  vim.notify(message, vim.log.levels.INFO)
end

---Copy the last visual selection as a fenced markdown code block.
---The fence info string carries the project-relative file name and the first
---line number of the selection.
function M.copy_as_codeblock()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    vim.notify("Buffer has no file name", vim.log.levels.WARN)
    return
  end

  local first = vim.fn.line("'<")
  local last = vim.fn.line("'>")
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)

  name = root.normalize(name)
  local path = root.relative(name, root.get()) or vim.fn.fnamemodify(name, ":~")
  local lang = fence_languages[vim.bo.filetype] or vim.bo.filetype

  local block = { string.format('```%s filename="%s" line=%d', lang, path, first) }
  vim.list_extend(block, lines)
  block[#block + 1] = "```"

  copy(table.concat(block, "\n"), string.format("Copied %d line%s as codeblock", #lines, #lines == 1 and "" or "s"))
end

---Delete all listed buffers that are not displayed in any window.
---Buffers with unsaved changes are kept.
function M.delete_hidden_buffers()
  local visible = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible[vim.api.nvim_win_get_buf(win)] = true
  end

  local deleted, skipped = 0, 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and not visible[buf] then
      if vim.bo[buf].modified then
        skipped = skipped + 1
      else
        vim.api.nvim_buf_delete(buf, {})
        deleted = deleted + 1
      end
    end
  end

  local message = string.format("Deleted %d hidden buffer%s", deleted, deleted == 1 and "" or "s")
  if skipped > 0 then
    message = string.format("%s (%d skipped, unsaved changes)", message, skipped)
  end
  vim.notify(message, vim.log.levels.INFO)
end

---Copy the current file path and line number as `<path>#L<line>`.
---@param modifier string Filename modifier: `":."` for relative, `":p"` for absolute.
local function yank_path_with_line(modifier)
  local path = vim.fn.expand("%" .. modifier) .. "#L" .. vim.fn.line(".")
  copy(path, "Yanked: " .. path)
end

---Copy the cwd-relative file path and line number.
function M.yank_relative_path_with_line()
  yank_path_with_line(":.")
end

---Copy the absolute file path and line number.
function M.yank_absolute_path_with_line()
  yank_path_with_line(":p")
end

return M
