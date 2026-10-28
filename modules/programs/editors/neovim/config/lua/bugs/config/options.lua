-- QoL built-in settings

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.title = true -- Use titlestring for window
vim.opt.cursorline = true -- Highlight current line
vim.opt.wrap = false -- Don't wrap lines
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- Indentation
vim.opt.tabstop = 2 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.softtabstop = 2 -- Soft tab stop
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true -- Copy indent from current line

-- Search settings
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Show matches as you type

-- Visual settings
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.matchtime = 2 -- How long to show matching bracket
vim.opt.cmdheight = 0 -- Command line height
vim.opt.completeopt = "menuone,noinsert,noselect" -- Completion options
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.pumheight = 10 -- Popup menu height
vim.opt.pumblend = 10 -- Popup menu transparency
vim.opt.winblend = 0 -- Floating window transparency
vim.opt.winborder = "rounded" -- The default border style of floating windows
vim.opt.pumborder = "none" -- The default border style on popup windows
vim.opt.conceallevel = 0 -- Don't hide markup
vim.opt.concealcursor = "" -- Don't hide cursor line markup
vim.opt.synmaxcol = 300 -- Syntax highlighting limit
vim.opt.laststatus = 3 -- Use global statusline

-- File handling
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before writing
vim.opt.swapfile = false -- Don't create swap files
vim.opt.undofile = true -- Persistent undo
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 500 -- Key timeout duration
vim.opt.ttimeoutlen = 0 -- Key code timeout
vim.opt.autoread = true -- Auto reload files changed outside vim
vim.opt.autowrite = false -- Don't auto save

-- Set undo directory path
local undodir = vim.fn.stdpath("state") .. "/undodir"

if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

vim.opt.undodir = undodir

-- Behavior settings
vim.opt.hidden = true -- Allow hidden buffers
vim.opt.errorbells = false -- No error bells
vim.opt.backspace = "indent,eol,start" -- Better backspace behavior
vim.opt.autochdir = false -- Don't auto change directory
vim.opt.iskeyword:append("-") -- Treat dash as part of word
vim.opt.path:append("**") -- Include subdirectories in search
vim.opt.wildignore:append({ "*/node_modules/*" }) -- Ignore node_modules
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.mousescroll = "ver:3,hor:0" -- Disable horizontal scrolling
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
vim.opt.modifiable = true -- Allow buffer modifications
vim.opt.exrc = true -- Enable project-local configuration

-- Spelling settings
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

-- Spell file settings
local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
local spell_file = spell_dir .. "/en.utf-8.add"

if vim.fn.isdirectory(spell_dir) == 0 then
  vim.fn.mkdir(spell_dir, "p")
end

vim.opt.spellfile = spell_file

-- Clipboard settings
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy --type text/plain",
    ["*"] = "wl-copy --primary --type text/plain",
  },
  paste = {
    ["+"] = { "sh", "-c", "wl-paste --no-newline 2>/dev/null || true" },
    ["*"] = { "sh", "-c", "wl-paste --primary --no-newline 2>/dev/null || true" },
  },
  cache_enabled = true,
}

-- Folding settings
vim.opt.foldcolumn = "1" -- Enable foldcolumn
vim.opt.foldlevelstart = 99 -- Start with all folds open
vim.opt.foldtext = "" -- Disable custom fold text rendering

-- Splitting behavior
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

-- Diff mode settings.
vim.opt.diffopt:append("followwrap,vertical,context:99")
vim.opt.shortmess:append({
  w = true,
  s = true,
})

-- Fill characters
local arrows = Utils.icons.arrows
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldclose = arrows.right,
  foldopen = arrows.down,
  foldsep = " ",
  foldinner = " ",
  msgsep = "─",
  diff = "/",
}

-- List characters
vim.opt.listchars = { space = "⋅", trail = "⋅", tab = "  ↦" }

-- Cursor settings
vim.opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Floating cmdline and messages using new ui2 module
require("vim._core.ui2").enable({
  msg = {
    targets = {
      [""] = "msg",
      bufwrite = "msg",
      echo = "msg",
      echomsg = "msg",
      lua_print = "msg",
      progress = "msg",
      quickfix = "msg",
      shell_ret = "msg",
      typed_cmd = "msg",
      undo = "msg",
      wmsg = "msg",

      empty = "cmd",
      confirm = "cmd",
      completion = "cmd",
      search_cmd = "cmd",
      search_count = "cmd",
      wildlist = "cmd",

      emsg = "pager",
      echoerr = "pager",
      lua_error = "pager",
      rpc_error = "pager",
      list_cmd = "pager",
      shell_cmd = "pager",
      shell_err = "pager",
      shell_out = "pager",
      verbose = "pager",
    },
    msg = { height = 0.3, timeout = 5000 },
  },
})

-- Disable some providers & improve performance
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
