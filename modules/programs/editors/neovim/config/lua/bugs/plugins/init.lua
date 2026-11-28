-- Require the plugin modules in a unified place

-- Treesitter
require("bugs.plugins.treesitter")
require("bugs.plugins.textobjects")

-- Snacks: The following modules only queue their specs; ui merges and sets them up in a single pass
require("bugs.plugins.picker")
require("bugs.plugins.terminal")
require("bugs.plugins.git")

-- UI
require("bugs.plugins.ui")

-- Editing
require("bugs.plugins.editing")

-- Diagnostics
require("bugs.plugins.diagnostics")

-- Debugging
require("bugs.plugins.dap")

-- Completions
require("bugs.plugins.completions")

-- Formatting
require("bugs.plugins.formatting")

-- Markdown
require("bugs.plugins.markdown")
