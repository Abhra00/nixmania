-- Import the package manager wrapper functions
local add_on_event = Utils.vim_pack.add_on_event

-- Import the helper function for setting keymaps
local map_keys = Utils.map.map_keys

-- Nvim-autopairs: Automatically close brackets and quotes
add_on_event("InsertEnter", {
  {
    src = "windwp/nvim-autopairs",
    on_setup = function()
      local Rule = require("nvim-autopairs.rule")
      local conds = require("nvim-autopairs.conds")

      -- Automatically close angle brackets that follow an identifier (generics, templates)
      require("nvim-autopairs").add_rule(Rule("<", ">", {
        -- Disabled for these filetypes to avoid conflicts with nvim-ts-autotag
        "-html",
        "-javascriptreact",
        "-typescriptreact",
      }):with_pair(conds.before_regex("%a+:?:?$", 3)):with_move(function(opts)
        return opts.char == ">"
      end))
    end,
  },
})

-- Nvim-ts-autotag: Automatically close and rename HTML and JSX/TSX tags
add_on_event({ "BufReadPre", "BufNewFile" }, { { src = "windwp/nvim-ts-autotag" } })

-- Grug far: Project-wide find and replace in an editable buffer (needs ripgrep)
add_on_event("UIEnter", {
  {
    src = "MagicDuck/grug-far.nvim",
    opts = {
      headerMaxWidth = 80,
    },
    on_setup = function()
      map_keys({
        {
          "<leader>sr",
          function()
            local grug = require("grug-far")
            -- Prefill the file filter with the current file's extension.
            local ext = vim.bo.buftype == "" and vim.fn.expand("%:e") or ""
            local opts = {
              transient = true,
              prefills = { filesFilter = ext ~= "" and ("*." .. ext) or nil },
            }
            if vim.fn.mode():match("[vV\22]") then
              grug.with_visual_selection(opts)
            else
              grug.open(opts)
            end
          end,
          mode = { "n", "x" },
          desc = "Search and replace",
        },
      })
    end,
  },
})
