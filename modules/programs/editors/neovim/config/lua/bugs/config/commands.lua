-- QoL commands

-- Toggle list characters
vim.api.nvim_create_user_command("ToggleListChars", function()
  vim.wo.list = not vim.wo.list
  local state = vim.wo.list and "enabled" or "disabled"
  vim.notify("Whitespace characters " .. state, vim.log.levels.INFO, { title = "ListChars" })
end, { desc = "Toggle display of whitespace characters [listchars]", nargs = 0 })

-- Toggle auto-formatting
vim.api.nvim_create_user_command("ToggleFormat", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(
    string.format("%s formatting...", vim.g.autoformat and "Enabling" or "Disabling"),
    vim.log.levels.INFO,
    { title = "AutoFormat" }
  )
end, { desc = "Toggle conform.nvim auto-formatting", nargs = 0 })

-- Toggle inlay hints
vim.api.nvim_create_user_command("ToggleInlayHints", function()
  vim.g.inlay_hints = not vim.g.inlay_hints
  vim.notify(
    string.format("%s inlay hints...", vim.g.inlay_hints and "Enabling" or "Disabling"),
    vim.log.levels.INFO,
    { title = "InlayHints" }
  )

  local mode = vim.api.nvim_get_mode().mode
  vim.lsp.inlay_hint.enable(vim.g.inlay_hints and (mode == "n" or mode == "v"))
end, { desc = "Toggle inlay hints", nargs = 0 })
