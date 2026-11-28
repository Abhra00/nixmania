local map_keys = require("bugs.utils.map").map_keys

local M = {}

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
  local function map(entries)
    for _, entry in ipairs(entries) do
      entry.buffer = bufnr
    end
    map_keys(entries)
  end

  local function supports(method)
    return client:supports_method(method, bufnr)
  end

  map({
    {
      "[e",
      function()
        vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
      end,
      desc = "Previous error",
    },
    {
      "]e",
      function()
        vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
      end,
      desc = "Next error",
    },
    {
      "<leader>cL",
      function()
        Snacks.picker.lsp_config()
      end,
      desc = "Lsp info",
    },
  })

  if supports("textDocument/hover") then
    map({
      {
        "K",
        function()
          return vim.lsp.buf.hover()
        end,
        desc = "Hover",
      },
    })
  end

  if supports("textDocument/signatureHelp") then
    map({
      {
        "<C-k>",
        function()
          -- Close the completion menu first so the popups don't overlap
          if require("blink.cmp").is_menu_visible() then
            require("blink.cmp").hide()
          end
          vim.lsp.buf.signature_help()
        end,
        mode = "i",
        desc = "Signature help",
      },
      {
        "gK",
        function()
          return vim.lsp.buf.signature_help()
        end,
        desc = "Signature help",
      },
    })
  end

  if supports("textDocument/definition") then
    map({
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Go to definition",
      },
      {
        "gD",
        function()
          Snacks.picker.lsp_definitions({ auto_confirm = false })
        end,
        desc = "Peek definition",
      },
    })
  end

  if supports("textDocument/references") then
    map({
      {
        "grr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "vim.lsp.buf.references()",
      },
    })
  end

  if supports("textDocument/implementation") then
    map({
      {
        "gri",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "vim.lsp.buf.implementation()",
      },
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Go to implementation",
      },
    })
  end

  if supports("textDocument/typeDefinition") then
    map({
      {
        "grt",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "vim.lsp.buf.type_definition()",
      },
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Go to type definition",
      },
    })
  end

  if supports("textDocument/documentSymbol") then
    map({
      {
        "<leader>fs",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "Document symbols",
      },
    })
  end

  if supports("workspace/symbol") then
    map({
      {
        "<leader>fS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Workspace symbols",
      },
    })
  end

  if supports("callHierarchy/incomingCalls") then
    map({
      {
        "gai",
        function()
          Snacks.picker.lsp_incoming_calls()
        end,
        desc = "Calls incoming",
      },
    })
  end

  if supports("callHierarchy/outgoingCalls") then
    map({
      {
        "gao",
        function()
          Snacks.picker.lsp_outgoing_calls()
        end,
        desc = "Calls outgoing",
      },
    })
  end

  if supports("textDocument/rename") then
    map({
      {
        "grn",
        function()
          vim.lsp.buf.rename()
        end,
        desc = "vim.lsp.buf.rename()",
      },
      {
        "<leader>cr",
        function()
          vim.lsp.buf.rename()
        end,
        desc = "Rename",
      },
    })
  end

  if supports("workspace/didRenameFiles") or supports("workspace/willRenameFiles") then
    map({
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename file",
      },
    })
  end

  if supports("textDocument/codeAction") then
    Utils.lightbulb.attach_lightbulb(bufnr, client)

    local actions = {
      {
        "<leader>ca",
        function()
          vim.lsp.buf.code_action()
        end,
        mode = { "n", "x" },
        desc = "Code action",
      },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
        end,
        desc = "Source action",
      },
    }

    -- Only bind organize imports if the server offers it
    local provider = client.server_capabilities.codeActionProvider
    local kinds = type(provider) == "table" and provider.codeActionKinds or {}
    local can_organize = vim.iter(kinds):any(function(kind)
      return kind:find("^source%.organizeImports")
    end)

    if can_organize then
      table.insert(actions, {
        "<leader>co",
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "source.organizeImports" }, diagnostics = {} },
          })
        end,
        desc = "Organize imports",
      })
    end

    map(actions)
  end

  if supports("textDocument/codeLens") then
    vim.lsp.codelens.enable(true)

    map({
      {
        "<leader>cc",
        function()
          vim.lsp.codelens.run()
        end,
        mode = { "n", "x" },
        desc = "Run codelens",
      },
    })
  end

  if supports("textDocument/documentColor") then
    map({
      {
        "grc",
        function()
          vim.lsp.document_color.color_presentation()
        end,
        mode = { "n", "x" },
        desc = "vim.lsp.document_color.color_presentation()",
      },
    })
  end

  if supports("textDocument/documentHighlight") then
    local group = vim.api.nvim_create_augroup("CursorHighlights", { clear = false })
    -- Clear first so re-running on_attach doesn't stack autocmds
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
      group = group,
      desc = "Highlight references under the cursor",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
      group = group,
      desc = "Clear highlight references",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    -- Bound unconditionally because Snacks.words enables itself on the first LspAttach, which can run after this handler
    map({
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next reference",
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Previous reference",
      },
      {
        "<A-n>",
        function()
          Snacks.words.jump(vim.v.count1, true)
        end,
        desc = "Next reference (cycle)",
      },
      {
        "<A-p>",
        function()
          Snacks.words.jump(-vim.v.count1, true)
        end,
        desc = "Previous reference (cycle)",
      },
    })
  end

  if supports("textDocument/inlayHint") then
    local group = vim.api.nvim_create_augroup("ToggleInlayHints", { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

    if vim.g.inlay_hints then
      -- Hints don't show on first load without a short delay
      vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        local mode = vim.api.nvim_get_mode().mode
        vim.lsp.inlay_hint.enable(mode == "n" or mode == "v", { bufnr = bufnr })
      end, 500)
    end

    vim.api.nvim_create_autocmd("InsertEnter", {
      group = group,
      desc = "Disable inlay hints in insert mode",
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end
      end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
      group = group,
      desc = "Enable inlay hints after insert mode",
      buffer = bufnr,
      callback = function()
        if vim.g.inlay_hints then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })
  end

  if client.name == "oxlint" then
    map({
      {
        "<leader>cl",
        function()
          local uri = vim.uri_from_bufnr(bufnr)
          local argument = { uri = uri }

          client:request("workspace/executeCommand", {
            command = "oxc.fixAll",
            arguments = { argument },
          }, nil, bufnr)
        end,
        desc = "Fix all OXLint errors",
      },
    })
  end
end

return M
