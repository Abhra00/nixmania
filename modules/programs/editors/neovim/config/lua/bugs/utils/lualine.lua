---@class utils.lualine
local M = {}

local icons = require("bugs.utils.icons")
local root = require("bugs.utils.root")

---Escape `%` so that file names cannot be parsed as statusline items.
---@param text string
---@return string
local function escape(text)
  return (text:gsub("%%", "%%%%"))
end

---Wrap `text` in a highlight group and restore the component's default highlight afterwards.
---@param component table
---@param text string
---@param hl_group? string
---@return string
function M.format(component, text, hl_group)
  text = escape(text)
  if not hl_group or hl_group == "" then
    return text
  end
  return "%#" .. hl_group .. "#" .. text .. component:get_default_hl()
end

---@class utils.lualine.PrettyPathOpts
---@field relative? "cwd"|"root" Base for the displayed path.
---@field length? integer Maximum number of path segments [`0` disables truncation, otherwise it must be greater than `1`. Default: `0`].
---@field directory_hl? string Highlight group for the directory part.
---@field filename_hl? string Highlight group for the file name.
---@field modified_hl? string Highlight group for the file name of a modified buffer.
---@field modified_sign? string Appended to the file name of a modified buffer.
---@field readonly_hl? string Highlight group for the readonly icon.
---@field readonly_icon? string Shown for readonly and non-modifiable buffers.

---Component that renders the current file path.
---
---Long paths are shortened to the first segment, an ellipsis and the last
---segments, e.g. `src/…/components/Button.lua`.
---@param opts? utils.lualine.PrettyPathOpts
---@return fun(self: table): string
function M.pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    length = 0,
    directory_hl = "",
    filename_hl = "LualineFile",
    modified_hl = "LualineFileModified",
    modified_sign = "",
    readonly_hl = "LualineFileReadonlyIcon",
    readonly_icon = " " .. icons.misc.lock .. " ",
  }, opts or {})
  assert(opts.length == 0 or opts.length > 1, "pretty_path: length must be 0 (disabled) or greater than 1")

  return function(self)
    local path = vim.fn.expand("%:p")
    if path == "" then
      return ""
    end

    -- Show the resolved path when it is inside the base, otherwise the path as it was opened.
    local real = root.normalize(path)
    local shown = vim.fs.joinpath(root.normalize(vim.fs.dirname(path)), vim.fs.basename(path))
    local cwd, project = root.cwd(), root.get()
    local rel
    if opts.relative == "cwd" then
      rel = root.relative(real, cwd) or root.relative(shown, cwd)
    end
    rel = rel or root.relative(real, project) or root.relative(shown, project) or vim.fn.fnamemodify(path, ":~")

    local lead = rel:sub(1, 1) == "/" and "/" or ""
    local parts = vim.split(rel, "/", { plain = true, trimempty = true })
    if opts.length > 0 and #parts > opts.length then
      parts = { parts[1], icons.misc.ellipsis, unpack(parts, #parts - opts.length + 2) }
    end

    local modified = vim.bo.modified
    local readonly = vim.bo.readonly or not vim.bo.modifiable

    local filename = parts[#parts] .. (modified and opts.modified_sign or "")
    filename = M.format(self, filename, modified and opts.modified_hl or opts.filename_hl)

    local dir = lead
    if #parts > 1 then
      dir = M.format(self, lead .. table.concat(parts, "/", 1, #parts - 1) .. "/", opts.directory_hl)
    end

    local suffix = readonly and M.format(self, opts.readonly_icon, opts.readonly_hl) or ""
    return dir .. filename .. suffix
  end
end

---@class utils.lualine.RootDirOpts
---@field cwd? boolean Show when the root equals the cwd. Default: `false`.
---@field subdirectory? boolean Show when the root is inside the cwd. Default: `true`.
---@field parent? boolean Show when the root is above the cwd. Default: `true`.
---@field other? boolean Show when the root and the cwd are unrelated. Default: `true`.
---@field icon? string
---@field hl? string Highlight group.

---Component that shows the project name when it differs from the cwd.
---@param opts? utils.lualine.RootDirOpts
---@return fun(self: table): string
function M.root_dir(opts)
  opts = vim.tbl_extend("force", {
    cwd = false,
    subdirectory = true,
    parent = true,
    other = true,
    icon = icons.misc.root_dir,
    hl = "LualineRootDir",
  }, opts or {})

  ---@return string? name The project name, or nil when it should be hidden.
  local function get()
    local cwd = root.cwd()
    local dir = root.get()

    local show
    if dir == cwd then
      show = opts.cwd
    elseif root.relative(dir, cwd) then
      show = opts.subdirectory
    elseif root.relative(cwd, dir) then
      show = opts.parent
    else
      show = opts.other
    end
    return show and vim.fs.basename(dir) or nil
  end

  return function(self)
    local name = get()
    if not name then
      return ""
    end
    return M.format(self, (opts.icon and opts.icon .. " " or "") .. name, opts.hl)
  end
end

---@class utils.lualine.MacroRecordingOpts
---@field icon? string
---@field hl? string Highlight group.

---Component that shows the register a macro is being recorded into.
---Add `RecordingEnter` to `options.refresh.events` so it appears immediately.
---`reg_recording()` is still set while `RecordingLeave` fires, so a refresh is
---scheduled from there instead of listing the event in `options.refresh.events`.
---@param opts? utils.lualine.MacroRecordingOpts
---@return fun(self: table): string
function M.macro_recording(opts)
  opts = vim.tbl_extend("force", {
    icon = icons.misc.recording,
    hl = "LualineMacroRecording",
  }, opts or {})

  vim.api.nvim_create_autocmd("RecordingLeave", {
    group = vim.api.nvim_create_augroup("LualineMacroRecordingRefresh", { clear = true }),
    callback = function()
      vim.schedule(function()
        local ok, lualine = pcall(require, "lualine")
        if ok then
          lualine.refresh()
        end
      end)
    end,
  })

  return function(self)
    local register = vim.fn.reg_recording()
    if register == "" then
      return ""
    end
    return M.format(self, opts.icon .. " " .. register, opts.hl)
  end
end

---@class utils.lualine.SearchCountOpts
---@field icon? string
---@field maxcount? integer Totals above this are shown as `>maxcount`.
---@field timeout? integer Milliseconds before the count is abandoned and shown as `?`.
---@field hl? string Highlight group.

---@class utils.lualine.SearchCount
---@field current integer
---@field total integer
---@field maxcount integer
---@field incomplete 0|1|2 0 = complete, 1 = timed out, 2 = exceeded maxcount

---Component that shows the position of the current search match, e.g. `3/12`.
---It is empty while search highlighting is off or the pattern has no matches.
---Pressing `<Esc>` schedules a refresh so the count disappears as soon as the highlight is cleared.
---@param opts? utils.lualine.SearchCountOpts
---@return fun(self: table): string
function M.search_count(opts)
  opts = vim.tbl_extend("force", {
    icon = icons.misc.search,
    maxcount = 999,
    timeout = 500,
    hl = "LualineSearchCount",
  }, opts or {})

  -- Clearing the search highlight fires no autocmd, so refresh on `<Esc>` to hide the count at once.
  local esc = vim.keycode("<Esc>")
  vim.on_key(function(key)
    if key == esc then
      vim.schedule(function()
        local ok, lualine = pcall(require, "lualine")
        if ok then
          lualine.refresh()
        end
      end)
    end
  end, vim.api.nvim_create_namespace("LualineSearchCountRefresh"))

  return function(self)
    if vim.v.hlsearch == 0 then
      return ""
    end

    local ok, sc = pcall(vim.fn.searchcount, {
      maxcount = opts.maxcount,
      timeout = opts.timeout,
    })
    if not ok or sc.total == nil or sc.total == 0 then
      return ""
    end

    local total
    if sc.incomplete == 1 then
      total = "?"
    elseif sc.incomplete == 2 then
      total = ">" .. sc.maxcount
    else
      total = tostring(sc.total)
    end

    return M.format(self, opts.icon .. " " .. ("%d/%s"):format(sc.current, total), opts.hl)
  end
end

---Clock glyphs, indexed by hour on a 12-hour dial (1 = 12 o'clock).
local clock_icons = icons.clock_icons

---Component function that renders the time as `<clock icon> HH:MM`.
---@return fun(): string
function M.pretty_time()
  return function()
    local now = os.date("*t")
    return string.format("%s %02d:%02d", clock_icons[now.hour % 12 + 1], now.hour, now.min)
  end
end

local lsp_work = {}

---@return boolean
local function lsp_busy()
  for _, count in pairs(lsp_work) do
    if count > 0 then
      return true
    end
  end
  return false
end

---Color for lsp_status: the spinner group while LSP work is in progress, otherwise the idle group.
---A table with only a foreground is returned because lualine drops the separator for string colors.
---@return table
function M.lsp_status_color()
  local name = lsp_busy() and "LualineLspSpinner" or "LualineLspStatus"
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  return { fg = hl.fg and ("#%06x"):format(hl.fg) or nil }
end

---Redraw the statusline in step with the lsp_status spinner while LSP work is in progress.
---Call it once during setup.
function M.animate_lsp_spinner()
  local frame_ns = 80e6
  local ticker = assert(vim.uv.new_timer())
  local shown

  local group = vim.api.nvim_create_augroup("LualineLspSpinnerRefresh", { clear = true })

  vim.api.nvim_create_autocmd("LspProgress", {
    group = group,
    callback = function(ev)
      local id, kind = ev.data.client_id, ev.data.params.value.kind
      lsp_work[id] = math.max((lsp_work[id] or 0) + (kind == "begin" and 1 or kind == "end" and -1 or 0), 0)
      if not lsp_busy() or ticker:is_active() then
        return
      end
      shown = nil
      ticker:start(0, 10, function()
        local frame = math.floor(vim.uv.hrtime() / frame_ns)
        if frame == shown then
          return
        end
        shown = frame
        vim.schedule(function()
          if not lsp_busy() then
            ticker:stop()
          end
          require("lualine").refresh({ place = { "statusline" }, force = true })
        end)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = group,
    callback = function(ev)
      lsp_work[ev.data.client_id] = nil
    end,
  })
end

---Component that shows the current document symbols location from Trouble.
---Disable it for a buffer with `vim.b.trouble_lualine = false`.
---@return table
function M.trouble_symbols()
  local symbols ---@type { get: fun(): string, has: fun(): boolean }?

  -- Trouble may not be loaded when lualine is set up, so resolve it on first use
  local function load()
    if not symbols then
      local ok, trouble = pcall(require, "trouble")
      if ok then
        symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
      end
    end
    return symbols
  end

  return {
    function()
      local s = load()
      return s and s.get() or ""
    end,
    cond = function()
      local s = load()
      return vim.g.trouble_lualine == true and vim.b.trouble_lualine ~= false and s ~= nil and s.has()
    end,
  }
end

return M
