-- Import the package manager wrapper functions
local add = Utils.vim_pack.add
local on_plugin_update = Utils.vim_pack.on_plugin_update

-- Import the helper function for setting keymaps
local map = Utils.map

-- Import the utilities
local install_list = Utils.treesitter.install_list

add({
  -- Treesitter: Highlight, edit, navigate code
  {
    src = "nvim-treesitter/nvim-treesitter",
    on_setup = function()
      -- Note: Main-branch nvim-treesitter ships queries under runtime/queries, which is not on the runtimepath by default
      -- Prepend it so highlights, folds, and indents are visible to vim.treesitter.start
      local init = vim.api.nvim_get_runtime_file("lua/nvim-treesitter/init.lua", false)[1]
      if init then
        vim.opt.runtimepath:prepend(vim.fn.fnamemodify(init, ":h:h:h") .. "/runtime")
      end

      require("nvim-treesitter").install(install_list()):wait(300000)
    end,
  },
  -- Treesitter context: Pins the current function/class header to the top of the window
  {
    src = "nvim-treesitter/nvim-treesitter-context",
    module_name = "treesitter-context",
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      min_window_height = 20,
    },
    on_setup = function()
      map.map_keys({
        {
          "[x",
          function()
            require("treesitter-context").go_to_context(vim.v.count1)
          end,
          desc = "Jump to upper context",
        },
      })
    end,
  },
})

on_plugin_update("nvim-treesitter", function()
  -- Re-install and update parsers.
  require("nvim-treesitter").install(install_list()):wait(300000)
  require("nvim-treesitter").update():wait(300000)
end)
