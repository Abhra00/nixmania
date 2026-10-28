-- C/C++ language server (clangd)
---@type vim.lsp.Config
return {
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
}
