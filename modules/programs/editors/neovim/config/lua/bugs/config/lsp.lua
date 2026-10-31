local map_keys = require("bugs.utils.map").map_keys
local diagnostic_icons = Utils.icons.diagnostics

local M = {}

vim.g.inlay_hints = false

local function title_case(name)
  return name:sub(1, 1) .. name:sub(2):lower()
end

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
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
    local group = vim.api.nvim_create_augroup("bugs/cursor_highlights", { clear = false })
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

    -- Bound unconditionally: Snacks.words enables itself on the first
    -- LspAttach, which can run after this handler
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
    local group = vim.api.nvim_create_augroup("bugs/toggle_inlay_hints", { clear = false })
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

  if client.name == "oxlint" or client.name == "stylelint_lsp" then
    local is_oxlint = client.name == "oxlint"

    map({
      {
        "<leader>cl",
        function()
          local uri = vim.uri_from_bufnr(bufnr)
          -- oxc.fixAll takes only the uri; stylelint also wants the buffer version
          local argument = is_oxlint and { uri = uri } or { uri = uri, version = vim.lsp.util.buf_versions[bufnr] }

          client:request("workspace/executeCommand", {
            command = is_oxlint and "oxc.fixAll" or "stylelint.applyAutoFixes",
            arguments = { argument },
          }, nil, bufnr)
        end,
        desc = string.format("Fix all %s errors", is_oxlint and "OXLint" or "Stylelint"),
      },
    })
  end
end

for name, icon in pairs(diagnostic_icons) do
  local hl = "DiagnosticSign" .. title_case(name)
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

vim.diagnostic.config({
  status = {
    format = function(counts)
      local items = {}
      for severity = vim.diagnostic.severity.ERROR, vim.diagnostic.severity.HINT do
        local count = counts[severity]
        if count and count > 0 then
          local name = vim.diagnostic.severity[severity]
          table.insert(items, ("%%#DiagnosticSign%s#%s %d"):format(title_case(name), diagnostic_icons[name], count))
        end
      end
      return table.concat(items, " ")
    end,
  },
  virtual_text = {
    prefix = "",
    spacing = 2,
    format = function(diagnostic)
      local short_sources = {
        ["Lua Diagnostics."] = "lua",
        ["Lua Syntax Check."] = "lua",
      }

      local message = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
      if diagnostic.source then
        message = message .. (short_sources[diagnostic.source] or diagnostic.source)
      end
      if diagnostic.code then
        message = string.format("%s[%s]", message, diagnostic.code)
      end

      return message .. " "
    end,
  },
  float = {
    source = "if_many",
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      return string.format(" %s ", diagnostic_icons[level]), "Diagnostic" .. title_case(level)
    end,
  },
  -- Icons are shown in virtual text instead of the gutter
  signs = false,
})

-- Most severe last, so it's the one virtual text renders in full
local show_handler = assert(vim.diagnostic.handlers.virtual_text.show)
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(a, b)
      return a.severity > b.severity
    end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end,
  hide = hide_handler,
}

local function sized(fn)
  return function(opts)
    return fn(vim.tbl_extend("keep", opts or {}, {
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    }))
  end
end

---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = sized(vim.lsp.buf.hover)
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = sized(vim.lsp.buf.signature_help)

-- Re-run on_attach after dynamic registration; the original handler goes
-- first so supports_method sees the new capability
local register_capability = vim.lsp.handlers["client/registerCapability"]
vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
  local result = register_capability(err, res, ctx)

  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client then
    for bufnr in pairs(client.attached_buffers) do
      on_attach(client, bufnr)
    end
  end

  return result
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      on_attach(client, args.buf)
    end
  end,
})

-- Enable every server defined in lsp/
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })

    local servers = vim
      .iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ":t:r")
      end)
      :totable()
    vim.lsp.enable(servers)
  end,
})

-- Silence notifications for methods a server doesn't implement
local buf_request = vim.lsp.buf_request
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf_request = function(bufnr, method, params, handler, on_unsupported)
  return buf_request(bufnr, method, params, handler, on_unsupported or function() end)
end

return M
