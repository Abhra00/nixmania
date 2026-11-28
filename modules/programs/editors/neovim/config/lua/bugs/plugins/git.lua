-- Import the package manager wrapper functions
local add_on_event = Utils.vim_pack.add_on_event
local collect = Utils.vim_pack.collect

-- Import the helper function for setting keymaps
local map_keys = Utils.map.map_keys

-- Import the needed icons
local solid_bar = Utils.icons.misc.vertical_bar
local dashed_bar = Utils.icons.misc.dashed_bar

-- Gitsigns: Git change indicators in the gutter
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

        -- Helper for building buffer-local hunk keymaps
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

-- Snacks (git): Lazygit integration and Git browse
collect({
  {
    src = "folke/snacks.nvim",
    opts = {
      lazygit = {
        enabled = true,
        configure = true,
        config = {
          os = {
            edit = Utils.lazygit.edit_command(),
            editAtLine = Utils.lazygit.edit_command({ at_line = true }),
          },
        },
        theme = {
          activeBorderColor = { fg = "SnacksLazygitActiveBorder", bold = true },
          inactiveBorderColor = { fg = "SnacksLazygitInactiveBorder" },
          searchingActiveBorderColor = { fg = "SnacksLazygitSearchBorder", bold = true },
          optionsTextColor = { fg = "SnacksLazygitOptionsText" },
          selectedLineBgColor = { bg = "SnacksLazygitSelectedLine" },
          cherryPickedCommitBgColor = { fg = "SnacksLazygitCherryBg" },
          cherryPickedCommitFgColor = { fg = "SnacksLazygitCherryFg" },
          unstagedChangesColor = { fg = "SnacksLazygitUnstaged" },
          defaultFgColor = { fg = "SnacksLazygitDefaultFg" },
        },
      },
    },
    on_setup = function()
      map_keys({
        {
          "<leader>gB",
          function()
            Snacks.gitbrowse()
          end,
          desc = "Git Browse",
          mode = { "n", "v" },
        },
        {
          "<leader>gg",
          function()
            require("bugs.utils.lazygit").open()
          end,
          desc = "Lazygit",
        },
      })
    end,
  },
})
