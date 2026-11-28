-- Emmet abbreviation expansion for markup/CSS
---@type vim.lsp.Config
return {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "less", "javascriptreact", "typescriptreact" },
  root_markers = { "package.json", ".git" },
  init_options = {
    showSuggestionsAsSnippets = true,
  },
}
