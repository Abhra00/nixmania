-- Helper function for setting up keymaps quickly

local M = {}

local keymap = vim.keymap

function M.map_keys(keymaps, defaults)
  defaults = defaults or {}
  for _, entry in ipairs(keymaps) do
    local function get(k)
      if entry[k] ~= nil then
        return entry[k]
      end
      return defaults[k]
    end
    keymap.set(entry.mode or defaults.mode or "n", entry[1], entry[2], {
      desc = entry.desc,
      silent = get("silent") ~= false,
      expr = get("expr"),
      nowait = get("nowait"),
      buffer = get("buffer"),
    })
  end
end

return M
