-- Import the necessary utilities
local add = Utils.vim_pack.add
local on_plugin_update = Utils.vim_pack.on_plugin_update
local map = Utils.map

-- Prepending nvim-treesitter's `runtime/` shadows Neovim's bundled queries for every language, not just the ones
-- listed below. Those queries track nvim-treesitter's parser revisions, so any parser Neovim bundles has to be
-- reinstalled from nvim-treesitter or the two drift apart and stuff breaks.
local function install_list()
  local parsers = {
    "bash",
    "c",
    "cpp",
    "css",
    "fish",
    "gitcommit",
    "go",
    "graphql",
    "html",
    "hyprlang",
    "java",
    "javascript",
    "json",
    "json5",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "python",
    "query",
    "rasi",
    "regex",
    "rust",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  }

  local set = {}
  for _, parser in ipairs(parsers) do
    set[parser] = true
  end

  local site = vim.fn.stdpath("data")
  for _, path in ipairs(vim.api.nvim_get_runtime_file("parser/*", true)) do
    -- Skip the parsers nvim-treesitter already installed under `site/`.
    if not vim.startswith(path, site) then
      set[vim.fn.fnamemodify(path, ":t:r")] = true
    end
  end

  return vim.tbl_keys(set)
end

local function select(query)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
  end
end

local function move(fn, query)
  return function()
    require("nvim-treesitter-textobjects.move")[fn](query, "textobjects")
  end
end

local function swap(fn, query)
  return function()
    require("nvim-treesitter-textobjects.swap")[fn](query)
  end
end

add({
  -- Treesitter: Highlight, edit, navigate code
  {
    src = "nvim-treesitter/nvim-treesitter",
    on_setup = function()
      -- N:B: Main-branch nvim-treesitter ships queries under `runtime/queries/`,
      -- which isn't on rtp by default. Prepend it so highlights/folds/indents
      -- are visible to `vim.treesitter.start`.
      local init = vim.api.nvim_get_runtime_file("lua/nvim-treesitter/init.lua", false)[1]
      if init then
        vim.opt.runtimepath:prepend(vim.fn.fnamemodify(init, ":h:h:h") .. "/runtime")
      end

      require("nvim-treesitter").install(install_list()):wait(300000)
    end,
  },
  -- Treesitter textobjects: Select, move and swap by syntax node
  {
    src = "nvim-treesitter/nvim-treesitter-textobjects",
    -- N:B: `master` is the old configs-style branch, doesn't work with main nvim-treesitter.
    version = "main",
    module_name = "nvim-treesitter-textobjects",
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },
    on_setup = function()
      map.map_keys({
        -- Select
        { "af", select("@function.outer"), mode = { "x", "o" }, desc = "Around function" },
        { "if", select("@function.inner"), mode = { "x", "o" }, desc = "Inside function" },
        { "ac", select("@class.outer"), mode = { "x", "o" }, desc = "Around class" },
        { "ic", select("@class.inner"), mode = { "x", "o" }, desc = "Inside class" },
        { "aa", select("@parameter.outer"), mode = { "x", "o" }, desc = "Around argument" },
        { "ia", select("@parameter.inner"), mode = { "x", "o" }, desc = "Inside argument" },
        { "ai", select("@conditional.outer"), mode = { "x", "o" }, desc = "Around conditional" },
        { "ii", select("@conditional.inner"), mode = { "x", "o" }, desc = "Inside conditional" },
        { "al", select("@loop.outer"), mode = { "x", "o" }, desc = "Around loop" },
        { "il", select("@loop.inner"), mode = { "x", "o" }, desc = "Inside loop" },

        -- Move (N:B: [c / ]c shadow the builtin diff hunk jumps)
        { "]f", move("goto_next_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function start" },
        { "]c", move("goto_next_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Next class start" },
        { "]a", move("goto_next_start", "@parameter.inner"), mode = { "n", "x", "o" }, desc = "Next argument" },
        { "]F", move("goto_next_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function end" },
        { "]C", move("goto_next_end", "@class.outer"), mode = { "n", "x", "o" }, desc = "Next class end" },
        {
          "[f",
          move("goto_previous_start", "@function.outer"),
          mode = { "n", "x", "o" },
          desc = "Prev function start",
        },
        { "[c", move("goto_previous_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Prev class start" },
        { "[a", move("goto_previous_start", "@parameter.inner"), mode = { "n", "x", "o" }, desc = "Prev argument" },
        { "[F", move("goto_previous_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Prev function end" },
        { "[C", move("goto_previous_end", "@class.outer"), mode = { "n", "x", "o" }, desc = "Prev class end" },

        -- Swap
        { "<M-l>", swap("swap_next", "@parameter.inner"), desc = "Swap next argument" },
        { "<M-h>", swap("swap_previous", "@parameter.inner"), desc = "Swap previous argument" },
      })
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
