-- Import the package manager wrapper functions
local add = Utils.vim_pack.add
local add_on_event = Utils.vim_pack.add_on_event

-- Import the helper function for setting keymap
local map = Utils.map.map_keys

add({
  -- Live preview: Live browser based preview for markdown & katex files with mermaid diagram support
  {
    src = "brianhuster/live-preview.nvim",
    setup = false,
    on_setup = function()
      local lp = require("livepreview.config")
      lp.set({
        port = 5500,
        browser = "default",
        dynamic_root = false,
        sync_scroll = true,
        address = "127.0.0.1",
      })
      map({
        { "<leader>lp", "<cmd>LivePreview pick<cr>", desc = "Pick file to preview live" },
      })
    end,
  },
})

-- Grug far: Project-wide find and replace in an editable buffer (needs ripgrep)
add_on_event("UIEnter", {
  {
    src = "MagicDuck/grug-far.nvim",
    opts = {
      headerMaxWidth = 80,
    },
    on_setup = function()
      map({
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
