-- Settings.
-- Core Neovim Settings.

-- Imports.
local arrows = require('icons').arrows

-- Leader Keys & Globals.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- UI & Display.
vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.wo.cursorline = false
vim.o.ruler = false
vim.opt.rulerformat = '%-14.(%l,%c%V%) %P'
vim.opt.list = true
vim.opt.listchars = { space = '⋅', trail = '⋅', tab = '  ↦' }
vim.o.linebreak = true
vim.o.laststatus = 3
vim.o.cmdheight = 1
vim.o.winborder = 'single'
vim.o.foldcolumn = '1'
vim.o.foldlevelstart = 99
vim.wo.foldtext = ''
vim.opt.fillchars = {
    eob = ' ',
    fold = ' ',
    foldclose = arrows.right,
    foldopen = arrows.down,
    foldsep = ' ',
    foldinner = ' ',
    msgsep = '─',
}
vim.o.guicursor = 'n-v-c:block-blinkwait175-blinkon400-blinkoff250,'
    .. 'i-ci-ve:ver25-blinkwait175-blinkon400-blinkoff250,'
    .. 'r-cr:hor20,'
    .. 'o:hor50'

-- Editing & Behavior.
vim.o.sw = 4
vim.o.ts = 4
vim.o.et = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:3,hor:0'
vim.o.undofile = true
vim.o.exrc = true
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10
vim.opt.shortmess:append { w = true, s = true }
vim.opt.diffopt:append 'followwrap,vertical,context:99'

-- Search & Completion.
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.wildignore:append { '.DS_Store' }
vim.o.completeopt = 'menuone,noselect,noinsert'
vim.o.pumheight = 15
vim.o.pumborder = 'single'

-- System Integration & Clipboard.
vim.o.clipboard = 'unnamedplus'
vim.g.clipboard = {
    name = 'wl-clipboard',
    copy = {
        ['+'] = 'wl-copy --type text/plain',
        ['*'] = 'wl-copy --primary --type text/plain',
    },
    paste = {
        ['+'] = { 'sh', '-c', 'wl-paste --no-newline 2>/dev/null || true' },
        ['*'] = { 'sh', '-c', 'wl-paste --primary --no-newline 2>/dev/null || true' },
    },
    cache_enabled = true,
}

-- Performance & Providers.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
