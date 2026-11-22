-- Import the package manager wrapper functions
local add = Utils.vim_pack.add
local add_on_event = Utils.vim_pack.add_on_event
local map_keys = Utils.map.map_keys

-- Import the needed icons
local solid_bar = Utils.icons.misc.vertical_bar
local dashed_bar = Utils.icons.misc.dashed_bar

-- Git signs: adds git related signs to the gutter
add_on_event({ "BufReadPre", "BufNewFile" }, {
  {
    src = "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = solid_bar },
        untracked = { text = solid_bar },
        change = { text = solid_bar },
        delete = { text = solid_bar },
        topdelete = { text = solid_bar },
        changedelete = { text = solid_bar },
      },
      signs_staged = {
        add = { text = dashed_bar },
        untracked = { text = dashed_bar },
        change = { text = dashed_bar },
        delete = { text = dashed_bar },
        topdelete = { text = dashed_bar },
        changedelete = { text = dashed_bar },
      },
      preview_config = { border = "rounded" },
      current_line_blame = true,
      gh = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Buffer-local hunk mappings.
        ---@param lhs string
        ---@param rhs function
        ---@param desc string
        local function nmap(lhs, rhs, desc)
          return { lhs, rhs, desc = desc, buffer = bufnr }
        end

        map_keys({
          nmap("[g", gs.prev_hunk, "Previous hunk"),
          nmap("]g", gs.next_hunk, "Next hunk"),
          nmap("<leader>ghR", gs.reset_buffer, "Reset buffer"),
          nmap("<leader>ghb", gs.blame_line, "Blame line"),
          nmap("<leader>ghp", gs.preview_hunk, "Preview hunk"),
          nmap("<leader>ghr", gs.reset_hunk, "Reset hunk"),
          nmap("<leader>ghs", gs.stage_hunk, "Stage hunk"),
        })
      end,
    },
  },
})

-- Nvim autopairs: Autoclosing braces & tokens
add_on_event("InsertEnter", {
  {
    src = "windwp/nvim-autopairs",
    on_setup = function()
      local Rule = require("nvim-autopairs.rule")
      local conds = require("nvim-autopairs.conds")

      -- Autoclosing angle-brackets.
      require("nvim-autopairs").add_rule(Rule("<", ">", {
        -- Avoid conflicts with nvim-ts-autotag.
        "-html",
        "-javascriptreact",
        "-typescriptreact",
      }):with_pair(conds.before_regex("%a+:?:?$", 3)):with_move(function(opts)
        return opts.char == ">"
      end))
    end,
  },
})

-- Nvim ts-autotag: Autoclosing tags for HTML and JSX/TSX
add_on_event({ "BufReadPre", "BufNewFile" }, { { src = "windwp/nvim-ts-autotag" } })

-- Trouble: Better diagnostics list and others
add_on_event("UIEnter", {
  {
    src = "folke/trouble.nvim",
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    on_setup = function()
      local trouble = require("trouble")

      local function step(trouble_fn, fallback)
        return function()
          if trouble.is_open() then
            trouble[trouble_fn]({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(fallback)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end
      end

      map_keys({
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
        { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
        { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
        { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
        { "[q", step("prev", vim.cmd.cprev), desc = "Previous Trouble/Quickfix Item" },
        { "]q", step("next", vim.cmd.cnext), desc = "Next Trouble/Quickfix Item" },
      })
    end,
  },
})

add({
  -- Todo comments: Highlight and search for todo comments like TODO, HACK, BUG in your code base
  {
    src = "folke/todo-comments.nvim",
    on_setup = function()
      local todo = require("todo-comments")

      map_keys({
        {
          "]t",
          function()
            todo.jump_next()
          end,
          desc = "Next todo comment",
        },
        {
          "[t",
          function()
            todo.jump_prev()
          end,
          desc = "Previous todo comment",
        },
        { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
        {
          "<leader>xT",
          "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
          desc = "Todo/Fix/Fixme (Trouble)",
        },
      })
    end,
  },
  -- Which key: Gives next keymap hints
  {
    src = "folke/which-key.nvim",
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        mode = { "n", "x" },
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>l", group = "live preview", icon = { icon = "", hl = "WhichKeyIconOrange" } },
        { "<leader>p", group = "packages", icon = { icon = "󰏓", hl = "WhichKeyIconAzure" } },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>x", group = "quickfix/diagnostics" },
        { "<leader>y", group = "yank", icon = { icon = "󰅇", hl = "WhichKeyIconYellow" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
      },
    },
  },
})
