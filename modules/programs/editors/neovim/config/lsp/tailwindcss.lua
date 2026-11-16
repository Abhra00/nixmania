-- Tailwind CSS class completion/hover for JS/TS/HTML
---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "css", "html" },
  root_markers = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "package.json" },
}
