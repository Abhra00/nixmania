-- Import the package manager wrapper functions
local add = Utils.vim_pack.add
local add_on_event = Utils.vim_pack.add_on_event

-- Import the helper function for setting keymaps
local map_keys = Utils.map.map_keys

-- Trouble: Diagnostics, symbols, LSP references, and quickfix/location lists
add_on_event("UIEnter", {
  {
    src = "folke/trouble.nvim",
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    on_setup = function()
      local trouble = require("trouble")

      local function step(trouble_fn, fallback)
        return function()
          if trouble.is_open() then
            trouble[trouble_fn]({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(fallback)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end
      end

      map_keys({
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
        { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
        { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
        { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
        { "[q", step("prev", vim.cmd.cprev), desc = "Previous Trouble/Quickfix Item" },
        { "]q", step("next", vim.cmd.cnext), desc = "Next Trouble/Quickfix Item" },
      })
    end,
  },
})

add({
  -- Todo comments: Highlight and search TODO, HACK, BUG, and similar comments across the codebase
  {
    src = "folke/todo-comments.nvim",
    on_setup = function()
      local todo = require("todo-comments")

      map_keys({
        {
          "]t",
          function()
            todo.jump_next()
          end,
          desc = "Next todo comment",
        },
        {
          "[t",
          function()
            todo.jump_prev()
          end,
          desc = "Previous todo comment",
        },
        { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
        {
          "<leader>xT",
          "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
          desc = "Todo/Fix/Fixme (Trouble)",
        },
      })
    end,
  },
})
