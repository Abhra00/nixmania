-- Lsp progress: native progress messages (rendered by ui2) with an animated spinner.
--
-- N:B: Neovim prepends "title: percent%" to progress messages when `title` / `percent` are passed to
-- nvim_echo(), coloured by status (OkMsg, MoreMsg, ...). Both are left out on purpose, so the whole
-- line is built from our own chunks and styled with the LspProgress* groups from the theme.

---@class utils.lsp_progress
local M = {}

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local done_icon = "✔"
local frame_interval = 100 -- ms

---@class bugs.LspProgressToken
---@field title string?
---@field message string?
---@field percent integer?

---@class bugs.LspProgressState
---@field frame integer
---@field timer uv.uv_timer_t
---@field tokens table<integer|string, bugs.LspProgressToken> Running tasks of the server
---@field current integer|string Token shown in the message
---@field last bugs.LspProgressToken Last shown token, kept for the final message

---@type table<integer, bugs.LspProgressState>
local progress = {}

---@param client_id integer
local function stop(client_id)
  local state = progress[client_id]
  if state then
    state.timer:stop()
    state.timer:close()
    progress[client_id] = nil
  end
end

---@param client_id integer
---@param done boolean?
local function echo_progress(client_id, done)
  local client = vim.lsp.get_client_by_id(client_id)
  local state = progress[client_id]
  if not client or not state then
    return
  end

  local token = done and state.last or state.tokens[state.current] or state.last
  local icon = done and done_icon or spinner[state.frame % #spinner + 1]

  local chunks = {
    { " " .. icon .. " ", done and "LspProgressDone" or "LspProgressSpinner" },
    { client.name, "LspProgressName" },
  }
  if token.title and token.title ~= "" then
    table.insert(chunks, { " " .. token.title, "LspProgressTitle" })
  end
  if token.message and token.message ~= "" then
    table.insert(chunks, { " " .. token.message, "LspProgressMessage" })
  end
  if not done and token.percent then
    table.insert(chunks, { (" %d%%"):format(token.percent), "LspProgressPercent" })
  end
  table.insert(chunks, { " " }) -- Right padding

  vim.api.nvim_echo(chunks, false, {
    id = "lsp." .. client_id, -- Same id per server, so updates replace the line in place
    kind = "progress",
    source = "vim.lsp",
    status = done and "success" or "running",
  })
end

---@param client_id integer
---@return bugs.LspProgressState
local function start(client_id)
  local state = {
    frame = 0,
    timer = assert(vim.uv.new_timer()),
    tokens = {},
    last = {},
  }
  progress[client_id] = state

  -- Servers only report now and then, so the timer drives the spinner animation
  state.timer:start(
    0,
    frame_interval,
    vim.schedule_wrap(function()
      local current = progress[client_id]
      if not current then
        return
      end
      -- The server went away mid-progress, don't keep animating
      if not vim.lsp.get_client_by_id(client_id) then
        stop(client_id)
        return
      end
      current.frame = current.frame + 1
      echo_progress(client_id)
    end)
  )

  return state
end

---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
local function on_progress(ev)
  local client_id = ev.data.client_id
  local token_id = ev.data.params.token
  local value = ev.data.params.value
  if type(value) ~= "table" then
    return
  end

  local state = progress[client_id]

  if value.kind == "end" then
    if not state then
      return
    end
    state.last = state.tokens[token_id] or state.last
    state.last.message = value.message or "done"
    state.tokens[token_id] = nil

    -- Servers often run several tasks at once; finish only when all are done
    if next(state.tokens) == nil then
      echo_progress(client_id, true)
      stop(client_id)
    end
    return
  end

  state = state or start(client_id)

  local token = state.tokens[token_id] or {}
  token.title = value.title or token.title
  if value.message ~= nil then
    token.message = value.message
  end
  token.percent = value.percentage or token.percent
  state.tokens[token_id] = token
  state.current = token_id
end

--- Start showing LSP progress. Safe to call more than once.
function M.setup()
  vim.api.nvim_create_autocmd("LspProgress", {
    group = vim.api.nvim_create_augroup("bugs/lsp_progress", { clear = true }),
    desc = "Show LSP progress as a native progress message",
    callback = on_progress,
  })
end

return M
