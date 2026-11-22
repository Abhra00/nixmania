---@class utils.cursorline
local M = {}

--- Whether the cursorline follows the active window.
M.enabled = true

local state = {
  active_win = nil, ---@type integer? last focused non-floating window
  has_focus = true, ---@type boolean whether the terminal has focus
  update_pending = false, ---@type boolean
}

---@param win integer
---@return boolean
local function is_floating(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

--- Only normal windows showing regular or help buffers are managed here.
--- Plugin-owned windows keep whatever cursorline setting their owner chose.
---@param win integer
---@return boolean
local function is_managed(win)
  if is_floating(win) then
    return false
  end
  local buftype = vim.bo[vim.api.nvim_win_get_buf(win)].buftype
  return buftype == "" or buftype == "help"
end

--- Recompute the cursorline of every managed window in the current tabpage.
--- Stateless by design: the desired value is derived from the current editor
--- state rather than saved and restored per window.
local function update_windows()
  state.update_pending = false

  local current = vim.api.nvim_get_current_win()
  if not is_floating(current) then
    state.active_win = current
  elseif state.active_win and not vim.api.nvim_win_is_valid(state.active_win) then
    state.active_win = nil
  end

  local visible = M.enabled and state.has_focus
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_managed(win) then
      local want = visible and win == state.active_win
      if vim.wo[win].cursorline ~= want then
        vim.api.nvim_set_option_value("cursorline", want, { win = win })
      end
    end
  end
end

--- Defer the update so buffer options are settled, and coalesce bursts of
--- events into a single update.
local function request_update()
  if state.update_pending then
    return
  end
  state.update_pending = true
  vim.schedule(update_windows)
end

--- Enable or disable the cursorline highlighting of the active window.
---@param enabled boolean
function M.set_enabled(enabled)
  M.enabled = enabled
  update_windows()
end

function M.toggle()
  M.set_enabled(not M.enabled)
end

--- Show the cursorline in the active window only.
function M.setup()
  local group = vim.api.nvim_create_augroup("ActiveWindowCursorline", { clear = true })

  vim.api.nvim_create_autocmd({
    "WinEnter",
    "WinNew",
    "WinClosed",
    "BufWinEnter",
    "TabEnter",
    "FileType",
    "VimEnter",
    "SessionLoadPost",
  }, { group = group, callback = request_update })

  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "buftype",
    callback = request_update,
  })

  vim.api.nvim_create_autocmd({ "FocusGained", "FocusLost" }, {
    group = group,
    callback = function(event)
      state.has_focus = event.event == "FocusGained"
      request_update()
    end,
  })

  vim.api.nvim_create_user_command("CursorlineToggle", M.toggle, {
    desc = "Toggle cursorline on the active window",
  })
end

return M
