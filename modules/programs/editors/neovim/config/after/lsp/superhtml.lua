-- HTML language server
---@type vim.lsp.Config
return {
  cmd = { "superhtml", "lsp" },
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
}
