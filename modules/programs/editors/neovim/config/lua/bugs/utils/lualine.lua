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

---Wrap `text` in a highlight group and restore `reset` afterwards.
---@param group string?
---@param text string
---@param reset string
---@return string
local function highlight(group, text, reset)
  text = escape(text)
  if not group or group == "" then
    return text
  end
  return "%#" .. group .. "#" .. text .. reset
end

---@class utils.lualine.PrettyPathOpts
---@field relative? "cwd"|"root" Base for the displayed path. Files outside it fall back to the project root, then to `~`-relative. Default: `"cwd"`.
---@field length? integer Maximum number of path segments; `0` disables truncation. Default: `3`.
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
    length = 3,
    directory_hl = "",
    filename_hl = "LualineFile",
    modified_hl = "LualineFileModified",
    modified_sign = "",
    readonly_hl = "LualineFileReadonlyIcon",
    readonly_icon = " " .. icons.misc.lock .. " ",
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p")
    if path == "" then
      return ""
    end

    -- Compare resolved paths, but display the path as it was opened so that
    -- symlinks (e.g. /etc/hosts on NixOS) keep their familiar name.
    local real = root.normalize(path)
    local rel = opts.relative == "cwd" and root.relative(real, root.cwd()) or nil
    rel = rel or root.relative(real, root.get()) or vim.fn.fnamemodify(path, ":~")

    local lead = rel:sub(1, 1) == "/" and "/" or ""
    local parts = vim.split(rel, "/", { plain = true, trimempty = true })
    if opts.length > 0 and #parts > opts.length then
      parts = { parts[1], icons.misc.ellipsis, unpack(parts, #parts - opts.length + 2) }
    end

    local reset = self:get_default_hl()
    local modified = vim.bo.modified
    local readonly = vim.bo.readonly or not vim.bo.modifiable

    local filename = parts[#parts] .. (modified and opts.modified_sign or "")
    filename = highlight(modified and opts.modified_hl or opts.filename_hl, filename, reset)

    local dir = lead
    if #parts > 1 then
      dir = highlight(opts.directory_hl, lead .. table.concat(parts, "/", 1, #parts - 1) .. "/", reset)
    end

    local suffix = readonly and highlight(opts.readonly_hl, opts.readonly_icon, reset) or ""
    return dir .. filename .. suffix
  end
end

---@class utils.lualine.RootDirOpts
---@field cwd? boolean Show when the root equals the cwd. Default: `false`.
---@field subdirectory? boolean Show when the root is inside the cwd. Default: `true`.
---@field parent? boolean Show when the root is above the cwd. Default: `true`.
---@field other? boolean Show when the root and the cwd are unrelated. Default: `true`.
---@field icon? string
---@field color? table|fun(): table

---Component that shows the project name when it differs from the cwd.
---@param opts? utils.lualine.RootDirOpts
---@return table
function M.root_dir(opts)
  opts = vim.tbl_extend("force", {
    cwd = false,
    subdirectory = true,
    parent = true,
    other = true,
    icon = icons.misc.root_dir,
    color = function()
      return { fg = Snacks.util.color("Special") }
    end,
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

  return {
    function()
      return (opts.icon and opts.icon .. " " or "") .. get()
    end,
    cond = function()
      return get() ~= nil
    end,
    color = opts.color,
  }
end

---@class utils.lualine.MacroRecordingOpts
---@field icon? string
---@field color? string|table|fun(): table Highlight group name or lualine color spec.

---Component that shows the register a macro is being recorded into.
---Add `RecordingEnter` and `RecordingLeave` to `options.refresh.events` so it
---updates immediately.
---@param opts? utils.lualine.MacroRecordingOpts
---@return table
function M.macro_recording(opts)
  opts = vim.tbl_extend("force", {
    icon = icons.misc.recording,
    color = "LualineMacroRecording",
  }, opts or {})

  return {
    function()
      return opts.icon .. " " .. vim.fn.reg_recording()
    end,
    cond = function()
      return vim.fn.reg_recording() ~= ""
    end,
    color = opts.color,
  }
end

---@class utils.lualine.SearchCountOpts
---@field icon? string
---@field maxcount? integer Totals above this are shown as `>maxcount`.
---@field timeout? integer Milliseconds before the count is abandoned and shown as `?`.
---@field color? string|table|fun(): table Highlight group name or lualine color spec.

---@class utils.lualine.SearchCount
---@field current integer
---@field total integer
---@field maxcount integer
---@field incomplete 0|1|2 0 = complete, 1 = timed out, 2 = exceeded maxcount

---Component that shows the position of the current search match, e.g. `3/12`.
---It is empty while search highlighting is off or the pattern has no matches.
---@param opts? utils.lualine.SearchCountOpts
---@return table
function M.search_count(opts)
  opts = vim.tbl_extend("force", {
    icon = icons.misc.search,
    maxcount = 999,
    timeout = 500,
    color = "LualineSearchCount",
  }, opts or {})

  return {
    function()
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

      return ("[%d/%s]"):format(sc.current, total)
    end,
    icon = opts.icon,
    color = opts.color,
  }
end

---Clock glyphs, indexed by hour on a 12-hour dial (1 = 12 o'clock).
local clock_icons = { "󱑊", "󱐿", "󱑀", "󱑁", "󱑂", "󱑃", "󱑄", "󱑅", "󱑆", "󱑇", "󱑈", "󱑉" }

---Component function that renders the time as `<clock icon> HH:MM`.
---@return fun(): string
function M.pretty_time()
  return function()
    local now = os.date("*t")
    return string.format("%s %02d:%02d", clock_icons[now.hour % 12 + 1], now.hour, now.min)
  end
end

return M
