-- Import the package manager wrapper functions
local add_on_event = Utils.vim_pack.add_on_event

-- Conform: Format buffer
add_on_event("BufWritePre", {
  {
    src = "stevearc/conform.nvim",
    opts = {
      notify_on_error = false,
      notify_no_formatters = false,
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        lua = { "stylua" },
        nix = { "alejandra" },
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        json = { "oxfmt" },
        jsonc = { "oxfmt" },
        json5 = { "oxfmt" },
        css = { "oxfmt" },
        scss = { "oxfmt" },
        toml = { "oxfmt" },
        html = { "superhtml" },
        markdown = { "oxfmt" },
        yaml = { "oxfmt" },
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      formatters = {
        oxfmt = {
          require_cwd = true,
        },
      },
      format_on_save = function()
        -- Stop if we disabled auto-formatting.
        if not vim.g.autoformat then
          return nil
        end
        return {}
      end,
    },
  },
})

-- Use conform for gq
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Start auto-formatting by default (and disable with my ToggleFormat command)
vim.g.autoformat = true
