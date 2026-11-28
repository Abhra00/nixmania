-- Import the package manager wrapper functions
local collect = Utils.vim_pack.collect

-- Import the helper function for setting keymaps
local map_keys = Utils.map.map_keys

-- Snacks (terminal): Terminal and scratch buffers
collect({
  {
    src = "folke/snacks.nvim",
    on_setup = function()
      map_keys({
        {
          "<leader>.",
          function()
            Snacks.scratch()
          end,
          desc = "Toggle Scratch Buffer",
        },
        {
          "<leader>S",
          function()
            Snacks.scratch.select()
          end,
          desc = "Select Scratch Buffer",
        },
        {
          "<c-/>",
          function()
            Snacks.terminal()
          end,
          desc = "Toggle Terminal",
        },
        {
          "<c-_>",
          function()
            Snacks.terminal()
          end,
          desc = "which_key_ignore",
        },
      })
    end,
  },
})
