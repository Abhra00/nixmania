-- Import the package manager wrapper functions
local add = Utils.vim_pack.add

-- Import the helper function for setting keymaps
local map_keys = Utils.map.map_keys

-- Import the kind icons
local kind_icons = Utils.icons.kinds

add({
  -- Blink lib: The optimized rust binary for fuzzy matching
  { src = "saghen/blink.lib", setup = false },
  -- LuaSnip: Snippet engine
  {
    src = "L3MON4D3/LuaSnip",
    module_name = "luasnip",
    opts = function()
      local types = require("luasnip.util.types")
      return {
        delete_check_events = "TextChanged",
        ext_opts = {
          [types.insertNode] = {
            unvisited = {
              virt_text = { { "|", "Conceal" } },
              virt_text_pos = "inline",
            },
          },
          [types.exitNode] = {
            unvisited = {
              virt_text = { { "|", "Conceal" } },
              virt_text_pos = "inline",
            },
          },
          [types.choiceNode] = {
            active = {
              virt_text = { { "(snippet) choice node", "LspInlayHint" } },
            },
          },
        },
      }
    end,
    on_setup = function()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = vim.fn.stdpath("config") .. "/snippets",
      })

      map_keys({
        {
          "<C-r>s",
          function()
            require("luasnip.extras.otf").on_the_fly("s")
          end,
          mode = "i",
          desc = "Insert on-the-fly snippet",
        },
        {
          "<C-c>",
          function()
            if require("blink.cmp").is_visible() then
              require("blink.cmp").hide()
            end
            ---@diagnostic disable-next-line: undefined-field
            if require("luasnip").choice_active() then
              require("luasnip.extras.select_choice")()
            end
          end,
          mode = { "i", "s" },
          desc = "Select choice",
        },
      })
    end,
  },
  -- Blink cmp: The actual completion menu
  {
    src = "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<CR>"] = { "accept", "fallback" },
        ["<C-\\>"] = { "hide", "fallback" },
        ["<C-n>"] = { "select_next", "show" },
        ["<C-p>"] = { "select_prev" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      completion = {
        list = {
          selection = { preselect = false, auto_insert = true },
          max_items = 10,
        },
        documentation = { auto_show = true },
        menu = {
          border = "none",
          scrollbar = false,
          draw = {
            gap = 2,
            columns = {
              { "kind_icon", "kind", gap = 1 },
              { "label", "label_description", gap = 1 },
            },
          },
        },
      },
      snippets = { preset = "luasnip" },
      cmdline = { enabled = false },
      sources = {
        default = function()
          local sources = { "lsp", "buffer" }
          local ok, node = pcall(vim.treesitter.get_node)
          local kind = ok and node and node:type() or ""

          if not kind:find("comment") then
            table.insert(sources, "path")
          end
          if not kind:find("string") then
            table.insert(sources, "snippets")
          end

          return sources
        end,
      },
      appearance = {
        kind_icons = kind_icons,
      },
    },
    on_setup = function()
      ---@diagnostic disable-next-line: undefined-field
      require("blink.cmp").build():pwait()
    end,
  },
})
