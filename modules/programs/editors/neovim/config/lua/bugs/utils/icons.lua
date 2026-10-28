local M = {}

-- stylua: ignore start
-- Diagnostic severities.
M.diagnostics = {
    ERROR = " ",
    WARN  = " ",
    HINT  = " ",
    INFO  = " ",
}

-- For folding.
M.arrows = {
  right = "",
  left  = "",
  up    = "",
  down  = "",
}

-- For statusline git status
M.git = {
  added    = " ",
  modified = " ",
  removed  = " ",
}

-- LSP symbol kinds.
M.symbol_kinds = {
  Array         = " ",
  Boolean       = "󰨙 ",
  Class         = " ",
  Codeium       = "󰘦 ",
  Color         = " ",
  Control       = " ",
  Collapsed     = " ",
  Constant      = "󰏿 ",
  Constructor   = " ",
  Copilot       = " ",
  Enum          = " ",
  EnumMember    = " ",
  Event         = " ",
  Field         = " ",
  File          = " ",
  Folder        = " ",
  Function      = "󰊕 ",
  Interface     = " ",
  Key           = " ",
  Keyword       = " ",
  Method        = "󰊕 ",
  Module        = " ",
  Namespace     = "󰦮 ",
  Null          = " ",
  Number        = "󰎠 ",
  Object        = " ",
  Operator      = " ",
  Package       = " ",
  Property      = " ",
  Reference     = " ",
  Snippet       = "󱄽 ",
  String        = " ",
  Struct        = "󰆼 ",
  Supermaven    = " ",
  TabNine       = "󰏚 ",
  Text          = " ",
  TypeParameter = " ",
  Unit          = " ",
  Value         = " ",
  Variable      = "󰀫 ",
}

-- For dap ui
M.dap = {
  Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint          = " ",
  BreakpointCondition = " ",
  BreakpointRejected  = { " ", "DiagnosticError" },
  LogPoint            = ".>",
}

-- Shared icons that don't really fit into a category.
M.misc = {
  bug          = "",
  dashed_bar   = "┊",
  ellipsis     = "…",
  git          = "",
  lock         = "󱎚",
  palette      = "󰏘",
  recording    = "󱔀",
  robot        = "󰚩",
  root_dir     = "󱉭",
  search       = "",
  terminal     = "",
  toolbox      = "󰦬",
  vertical_bar = "│",
}

-- stylua: ignore end

return M
