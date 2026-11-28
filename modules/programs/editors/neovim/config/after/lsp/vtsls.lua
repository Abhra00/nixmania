-- Lsp for JS/TS/JSX/TSX

local js_ts_settings = {
  updateImportsOnFileMove = { enabled = "always" },
  suggest = { completeFunctionCalls = true },
  preferences = { useAliasesForRenames = false },
  inlayHints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = false },
  },
}

---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  on_attach = function(client)
    if client.server_capabilities.semanticTokensProvider then
      client.server_capabilities.semanticTokensProvider.range = false
    end
  end,
  settings = {
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = { enableServerSideFuzzyMatch = true },
      },
    },
    typescript = js_ts_settings,
    javascript = js_ts_settings,
  },
}
