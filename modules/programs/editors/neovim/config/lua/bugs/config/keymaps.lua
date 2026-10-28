-- QoL keymaps

-- Import the necessary utilities
local map_keys = require("bugs.utils.map").map_keys
local tabline = require("bugs.utils.tabline")

map_keys({

  -- Keep the cursor centered
  { "<C-d>", "<C-d>zz" },
  { "<C-u>", "<C-u>zz" },
  { "n", "nzzzv" },
  { "N", "Nzzzv" },

  -- Increment/decrement
  { "+", "<C-a>" },
  { "-", "<C-x>" },

  -- Delete a word backwards
  { "dw", 'vb"_d' },

  -- Select all
  { "<C-a>", "<cmd>keepjumps normal! ggVG<cr>" },

  -- Disable continuations
  { "<Leader>o", "o<Esc>^Da", desc = "which_key_ignore" },
  { "<Leader>O", "O<Esc>^Da", desc = "which_key_ignore" },

  -- Jumplist
  { "<C-m>", "<C-i>" },

  -- Tabs
  { "te", ":tabedit<CR>" },
  { "<tab>", ":tabnext<CR>" },
  { "<s-tab>", ":tabprev<CR>" },
  { "tp", tabline.pick },
  {
    "tx",
    function()
      tabline.pick(function(tabnr)
        vim.cmd(tabnr .. "tabclose")
      end)
    end,
  },

  -- Split window
  { "ss", ":split<Return>" },
  { "sv", ":vsplit<Return>" },

  -- Move window
  { "sh", "<C-w>h" },
  { "sk", "<C-w>k" },
  { "sj", "<C-w>j" },
  { "sl", "<C-w>l" },

  -- Buffers
  { "<leader>bp", ":bprevious<Return>", desc = "Previous buffer" },
  { "<leader>bn", ":bnext<Return>", desc = "Next buffer" },
  {
    "<leader>bd",
    function()
      Snacks.bufdelete()
    end,
    desc = "Delete buffer",
  },
  {
    "<leader>bD",
    function()
      require("bugs.utils.editor").delete_hidden_buffers()
    end,
    desc = "Delete hidden buffers",
  },

  -- Formatting
  { "gQ", "mzgggqG`z<cmd>delmarks z<cr>zz", desc = "Format buffer" },

  -- EOL
  { "<C-l>", "<End>", mode = { "i", "c" } },

  -- Powerful <esc>
  {
    "<esc>",
    function()
      ---@diagnostic disable: undefined-field
      if require("luasnip").expand_or_jumpable() then
        require("luasnip").unlink_current()
      end
      ---@diagnostic enable: undefined-field
      vim.cmd("noh")
      return "<esc>"
    end,
    mode = { "i", "s", "n" },
    expr = true,
    desc = "Escape, clear hlsearch, and stop snippet session",
  },

  -- Packages
  {
    "<leader>pu",
    function()
      vim.pack.update()
    end,
    desc = "Update packages",
  },
  {
    "<leader>ps",
    function()
      vim.pack.update(nil, { lockfile = true })
    end,
    desc = "Sync packages",
  },

  -- Markpoon
  {
    "`",
    function()
      require("bugs.utils.markpoon").toggle()
    end,
    desc = "Open markpoon window",
  },

  -- Yank current file path[relative] with line number
  {
    "<leader>yf",
    function()
      require("bugs.utils.editor").yank_relative_path_with_line()
    end,
    desc = "Yank relative path with line number",
  },

  -- Yank current file path[absolute] with line number
  {
    "<leader>yp",
    function()
      require("bugs.utils.editor").yank_absolute_path_with_line()
    end,
    desc = "Yank absolute path with line number",
  },

  -- Yank selected area as codeblock
  {
    "<leader>yc",
    ":<C-u>lua require('bugs.utils.editor').copy_as_codeblock()<CR>",
    mode = "x",
    desc = "Yank selected area as codeblock",
  },
})
