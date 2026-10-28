-- QoL autocommands

local map_keys = require("bugs.utils.map").map_keys

-- Helper function for creating group
local function create_group(name, opts)
  return vim.api.nvim_create_augroup(name, opts)
end

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  group = create_group("bugs/disable_paste_mode", {}),
  desc = "Disable paste mode after leaving insert",
  callback = function()
    vim.o.paste = false
  end,
})

-- Group for cursorline autocmds
local cursorline_group = create_group("bugs/cursorline_group", { clear = true })

-- Disable cursorline on inactive window
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  group = cursorline_group,
  desc = "Disable cursorline on inactive window",
  callback = function()
    if vim.wo.cursorline then
      vim.w.cursorline_enabled = true
      vim.wo.cursorline = false
    end
  end,
})

-- Highlight cursorline on active window
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  group = cursorline_group,
  desc = "Highlight cursorline on active window",
  callback = function()
    if vim.w.cursorline_enabled then
      vim.wo.cursorline = true
      vim.w.cursorline_enabled = nil
    end
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = create_group("bugs/highlight_on_yank", {}),
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank({ higroup = "YankHighlight", timeout = 150 })
  end,
})

-- Treesitter folding + indent
vim.api.nvim_create_autocmd("FileType", {
  group = create_group("bugs/treesitter_folding", { clear = true }),
  desc = "Enable Treesitter folding and indent",
  callback = function(args)
    local bufnr = args.buf
    if vim.bo[bufnr].filetype ~= "bigfile" and pcall(vim.treesitter.start, bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.cmd.normal("zx")
      end)
      vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Add the ability to close some buffers with q
vim.api.nvim_create_autocmd("FileType", {
  group = create_group("bugs/close_with_q", { clear = true }),
  desc = "Close with <q>",
  pattern = {
    "git",
    "help",
    "man",
    "qf",
    "scratch",
    "nvim-pack",
  },
  callback = function(args)
    if args.match ~= "help" or not vim.bo[args.buf].modifiable then
      map_keys({
        { "q", "<cmd>quit<cr>", desc = "Close buffer", buffer = args.buf },
      })
    end
  end,
})

-- Remember last location
vim.api.nvim_create_autocmd("BufReadPost", {
  group = create_group("bugs/last_location", { clear = true }),
  desc = "Go to the last location when opening a buffer",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

-- Lsp progress
require("bugs.utils.lsp-progress").setup()
