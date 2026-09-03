-- Enable the experimental Lua module loader.
vim.loader.enable()

-- Global variables.
vim.g.projects_dir = vim.env.HOME .. "/Projects"

-- Set my colorscheme.
vim.cmd.colorscheme("stylix")

-- General setup and goodies (order matters here).
require("settings")

-- Interactive textual undotree:
vim.cmd.packadd("nvim.undotree")

-- Enable the new experimental command-line features.
require("vim._core.ui2").enable({})
