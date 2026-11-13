-- Thin wrapper around vim.pack for adding and configuring plugins.
-- Credits: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/vim-pack.lua

local M = {}

local group = vim.api.nvim_create_augroup("bugs/vim_pack", { clear = false })

---@class PluginSpec
---@field src string GitHub owner/repo, a git URL (https://, ssh://, git@host:) or a local path
---@field version? string|vim.VersionRange Branch, tag, commit or semver range. Defaults to the remote's default branch
---@field name? string Defaults to the last segment of src without .git
---@field module_name? string Module to require for setup. Defaults to the plugin name without .nvim
---@field opts? table|fun():table Options passed to setup()
---@field on_setup? fun():nil Runs after the plugin is set up
---@field setup? false Skip require and setup() (vimscript-only or data-only plugins)

---@param msg string
local function report(msg)
  vim.notify("vim-pack: " .. msg, vim.log.levels.ERROR)
end

---@param src string
---@return string
local function to_url(src)
  -- Full URLs are used as they are
  if src:find("^[%w+.-]+://") or src:find("^git@") then
    return src
  end
  -- Local paths, with ~ and $VARS expanded
  if src:find("^[/~.]") then
    return vim.fs.normalize(src)
  end
  -- Anything else is a GitHub owner/repo
  return string.format("https://github.com/%s", src)
end

---The name vim.pack gives the plugin.
---@param plugin PluginSpec
---@return string
local function plugin_name(plugin)
  if plugin.name then
    return plugin.name
  end
  local url = to_url(plugin.src):gsub("/+$", ""):gsub("%.git$", "")
  return url:match("[^/:]+$") or url
end

---@param plugin PluginSpec
---@return string
local function module_name(plugin)
  return plugin.module_name or (plugin_name(plugin):gsub("%.nvim$", ""))
end

---Run fn and report a failure instead of raising it.
---@param plugin PluginSpec
---@param what string
---@param fn function
---@return boolean ok
---@return any result
local function try(plugin, what, fn)
  local ok, result = pcall(fn)
  if not ok then
    report(string.format("%s: %s failed: %s", plugin_name(plugin), what, result))
  end
  return ok, result
end

---Require the plugin's module, call its setup(), then run on_setup.
---A failing plugin is reported and skipped.
---@param plugin PluginSpec
local function setup_plugin(plugin)
  if plugin.setup ~= false then
    local ok, mod = try(plugin, "require('" .. module_name(plugin) .. "')", function()
      return require(module_name(plugin))
    end)
    if not ok then
      return
    end

    -- The module may not return a table or define setup
    if type(mod) == "table" and type(mod.setup) == "function" then
      local opts_ok, opts = true, plugin.opts
      if type(opts) == "function" then
        opts_ok, opts = try(plugin, "opts()", opts)
      end
      if not opts_ok or not try(plugin, "setup()", function()
        mod.setup(opts or {})
      end) then
        return
      end
    end
  end

  if plugin.on_setup then
    try(plugin, "on_setup()", plugin.on_setup)
  end
end

---@param plugins PluginSpec[]
local function configure(plugins)
  local specs, unique, seen = {}, {}, {}
  for _, plugin in ipairs(plugins) do
    vim.validate("plugin.src", plugin.src, "string")
    local url = to_url(plugin.src)
    -- If a plugin is listed twice, the first spec wins
    if not seen[url] then
      seen[url] = true
      unique[#unique + 1] = plugin
      -- A nil version tracks the remote's default branch
      specs[#specs + 1] = { src = url, version = plugin.version, name = plugin.name }
    end
  end

  local ok, err = pcall(vim.pack.add, specs)
  if not ok then
    -- E.g. a failed clone. The remaining plugins are still set up
    report("vim.pack.add failed: " .. tostring(err))
  end

  for _, plugin in ipairs(unique) do
    setup_plugin(plugin)
  end
end

---@param event vim.api.keyset.events|vim.api.keyset.events[]
---@param pattern? string|string[]
---@param plugins PluginSpec[]
local add_on_event = function(event, pattern, plugins)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    once = true,
    desc = "Add plugins: " .. table.concat(vim.tbl_map(plugin_name, plugins), ", "),
    callback = function()
      configure(plugins)
    end,
  })
end

---Add and configure plugins right away.
---
---@param plugins PluginSpec[]
function M.add(plugins)
  configure(plugins)
end

---Add and configure plugins the first time the event fires.
---
---@param event vim.api.keyset.events|vim.api.keyset.events[]
---@param plugins PluginSpec[]
function M.add_on_event(event, plugins)
  add_on_event(event, nil, plugins)
end

---Add and configure plugins the first time a matching filetype is opened.
---
---@param patterns string|string[]
---@param plugins PluginSpec[]
function M.add_on_file_type(patterns, plugins)
  add_on_event("FileType", patterns, plugins)
end

---Run a command after the plugin is installed or updated.
---
---N:B: Call this before the vim.pack.add that installs the plugin, or the first install is missed.
---
---@param name string Plugin name
---@param cmd string|string[]|fun(data: table):nil Command run in the plugin directory (a string is split on
--- whitespace, no shell is involved), or a function that receives the PackChanged event data
function M.on_plugin_update(name, cmd)
  vim.validate("cmd", cmd, { "string", "table", "function" })

  vim.api.nvim_create_autocmd("PackChanged", {
    group = group,
    desc = "Run the update hook of " .. name,
    callback = function(args)
      local data = args.data
      if data.spec.name ~= name or (data.kind ~= "install" and data.kind ~= "update") then
        return
      end

      -- Right after an install the plugin may not be on the runtimepath yet
      if not data.active then
        pcall(vim.cmd.packadd, name)
      end

      if type(cmd) == "function" then
        local ok, err = pcall(cmd, data)
        if not ok then
          report(string.format("%s: update hook failed: %s", name, err))
        end
        return
      end

      ---@type string[]
      local argv
      if type(cmd) == "string" then
        argv = vim.split(cmd, "%s+", { trimempty = true })
      else
        argv = cmd
      end

      local started, err = pcall(
        vim.system,
        argv,
        { cwd = data.path },
        vim.schedule_wrap(function(res)
          if res.code ~= 0 then
            report(
              string.format("%s: `%s` exited with %d: %s", name, table.concat(argv, " "), res.code, res.stderr or "")
            )
          end
        end)
      )
      if not started then
        report(string.format("%s: couldn't run `%s`: %s", name, table.concat(argv, " "), err))
      end
    end,
  })
end

return M
