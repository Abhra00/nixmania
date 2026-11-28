-- Import the package manager wrapper functions
local add = Utils.vim_pack.add

-- Import the helper function for setting keymaps
local map_keys = Utils.map.map_keys

add({
  -- Live preview: Browser-based live preview for Markdown and KaTeX, with Mermaid diagram support
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
      map_keys({
        { "<leader>lp", "<cmd>LivePreview pick<cr>", desc = "Pick file to preview live" },
      })
    end,
  },
})
