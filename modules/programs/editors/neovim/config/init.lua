-- Enable the new lua loader module
vim.loader.enable()

-- Set the colorscheme
vim.cmd([[colorscheme stylix]])

-- Keep my utils in a global variable
_G.Utils = require("bugs.utils")

-- Setup tabline
Utils.tabline.setup()

-- Initialize the individual modules
require("bugs.config.options")
require("bugs.config.keymaps")
require("bugs.config.commands")
require("bugs.config.autocmds")
require("bugs.config.lsp")
require("bugs.plugins")
