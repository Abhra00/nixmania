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

-- Quicker nvim: Improved quickfix ui
add_on_event("UIEnter", {
  {
    src = "stevearc/quicker.nvim",
    opts = {
      borders = { vert = solid_bar },
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse context",
        },
      },
    },
    on_setup = function()
      local quicker = require("quicker")

      vim.keymap.set("n", "<leader>xq", function()
        quicker.toggle()
      end, { desc = "Toggle quickfix" })
      vim.keymap.set("n", "<leader>xl", function()
        quicker.toggle({ loclist = true })
      end, { desc = "Toggle loclist" })
      vim.keymap.set("n", "<leader>xd", function()
        if quicker.is_open() then
          quicker.close()
        else
          vim.diagnostic.setqflist()
        end
      end, { desc = "Toggle diagnostics" })
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
