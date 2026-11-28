local diagnostic_icons = Utils.icons.diagnostics
local on_attach = require("bugs.config.lsp.keymaps").on_attach

local function title_case(name)
  return name:sub(1, 1) .. name:sub(2):lower()
end

for name, icon in pairs(diagnostic_icons) do
  local hl = "DiagnosticSign" .. title_case(name)
  vim.fn.sign_define(hl, { text = icon .. " ", texthl = hl })
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

      local message = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]] .. " "
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
  -- Severity icons are rendered in the virtual text, so the sign column is disabled
  signs = false,
})

-- Order diagnostics from least to most severe so the most severe one is rendered in full
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

-- Re-run on_attach after dynamic capability registration
-- The original handler runs first so that supports_method sees the new capability
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

-- Enable every server configured under after/lsp
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

-- Suppress the notification shown when a server does not support a requested method
local buf_request = vim.lsp.buf_request
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf_request = function(bufnr, method, params, handler, on_unsupported)
  return buf_request(bufnr, method, params, handler, on_unsupported or function() end)
end
