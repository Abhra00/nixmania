-- JSON language server (vscode-json-languageserver)
---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git" },
  init_options = { provideFormatter = false },
  settings = {
    json = { validate = { enable = true } },
  },
}
