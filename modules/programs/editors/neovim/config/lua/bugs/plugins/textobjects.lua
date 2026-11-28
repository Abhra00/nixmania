-- Import the package manager wrapper functions
local add = Utils.vim_pack.add

-- Import the helper function for setting keymaps
local map_keys = Utils.map.map_keys

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
  -- Treesitter textobjects: Select, move and swap by syntax node
  {
    src = "nvim-treesitter/nvim-treesitter-textobjects",
    module_name = "nvim-treesitter-textobjects",
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },
    on_setup = function()
      map_keys({
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

        -- Move
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
})
