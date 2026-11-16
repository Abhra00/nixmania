---@class utils.root
local M = {}

---Files and directories that mark a project root.
local markers = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

---Normalize a path: expand `~`, drop trailing slashes and resolve symlinks.
---Paths that do not exist are returned normalized but otherwise unchanged.
---@param path string
---@return string
function M.normalize(path)
  path = vim.fs.normalize(path)
  return vim.uv.fs_realpath(path) or path
end

---Current working directory.
---@return string
function M.cwd()
  return M.normalize(vim.uv.cwd() or vim.fn.getcwd())
end

---Return `path` relative to `dir`, or nil when `path` is not strictly inside `dir`.
---Both paths are expected to be normalized.
---@param path string
---@param dir string
---@return string?
function M.relative(path, dir)
  local prefix = dir:sub(-1) == "/" and dir or dir .. "/"
  if path:sub(1, #prefix) == prefix then
    return path:sub(#prefix + 1)
  end
end

---Deepest LSP workspace root that contains `path`.
---@param buf integer
---@param path string
---@return string?
local function lsp_root(buf, path)
  local best
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    local dirs = { client.root_dir }
    for _, folder in ipairs(client.workspace_folders or {}) do
      dirs[#dirs + 1] = vim.uri_to_fname(folder.uri)
    end
    for _, dir in ipairs(dirs) do
      dir = M.normalize(dir)
      if M.relative(path, dir) and (not best or #dir > #best) then
        best = dir
      end
    end
  end
  return best
end

---Nearest directory at or above `start` that contains one of the root markers.
---@param start string
---@return string?
local function marker_root(start)
  local found = vim.fs.find(markers, { path = start, upward = true })[1]
  return found and M.normalize(vim.fs.dirname(found)) or nil
end

---Project root for a buffer. Resolution order: LSP workspace, root markers, cwd.
---The result is cached per buffer; see the autocmds below for invalidation.
---@param buf? integer Defaults to the current buffer.
---@return string
function M.get(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local cached = vim.b[buf].bugs_root
  if cached then
    return cached
  end

  local name = vim.api.nvim_buf_get_name(buf)
  local root
  if name ~= "" and vim.bo[buf].buftype == "" then
    name = M.normalize(name)
    root = lsp_root(buf, name) or marker_root(vim.fs.dirname(name))
  else
    root = marker_root(M.cwd())
  end

  root = root or M.cwd()
  vim.b[buf].bugs_root = root
  return root
end

local group = vim.api.nvim_create_augroup("bugs_root_cache", { clear = true })

vim.api.nvim_create_autocmd({ "BufFilePost", "LspAttach", "LspDetach" }, {
  group = group,
  desc = "Invalidate the cached project root of a buffer",
  callback = function(ev)
    vim.b[ev.buf].bugs_root = nil
  end,
})

vim.api.nvim_create_autocmd("DirChanged", {
  group = group,
  desc = "Invalidate all cached project roots",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      vim.b[buf].bugs_root = nil
    end
  end,
})

return M
