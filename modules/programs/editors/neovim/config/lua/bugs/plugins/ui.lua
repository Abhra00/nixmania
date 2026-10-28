-- Import the package manager wrapper functions
local add = Utils.vim_pack.add

-- Import icons
local icons = Utils.icons

-- Import the utilities
local map_keys = Utils.map.map_keys
local lualine_utils = Utils.lualine
local lazygit_utils = Utils.lazygit

-- Plugin picker helper function
local function plugin_picker()
  local items = {}
  for _, plug in ipairs(vim.pack.get()) do
    items[#items + 1] = {
      text = plug.spec.name,
      file = plug.path,
      dir = true,
    }
  end
  Snacks.picker.pick({
    title = "Plugins",
    items = items,
    format = "text",
    preview = "directory",
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      Snacks.picker.files({
        cwd = item.file,
        title = vim.fn.fnamemodify(item.file, ":t"),
        actions = {
          back_to_plugins = function(files)
            files:close()
            vim.schedule(plugin_picker)
          end,
        },
        win = {
          input = {
            keys = {
              ["<M-p>"] = { "back_to_plugins", mode = { "i", "n" } },
            },
          },
        },
      })
    end,
  })
end

add({
  -- Mini.icons: Colored icons used by various plugins
  {
    src = "nvim-mini/mini.icons",
    on_setup = function()
      local mini_icons = require("mini.icons")
      mini_icons.setup()
      mini_icons.mock_nvim_web_devicons()
    end,
  },
  -- Snacks.nvim: Picker,explorer,indent-guides,etc...
  {
    src = "folke/snacks.nvim",
    opts = {
      animate = { enabled = true },
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        width = 90,
        preset = { header = require("bugs.utils.ascii-art") },
        sections = {
          { section = "header", padding = 1 },
          {
            section = "terminal",
            cmd = "drift --scene rain --theme cosmic --duration 0",
            hl = "header",
            width = 90,
            padding = 1,
            align = "center",
          },
        },
      },
      explorer = { enabled = true },
      image = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = {
        enabled = true,
        configure = true,
        config = {
          os = {
            edit = lazygit_utils.edit_command(),
            editAtLine = lazygit_utils.edit_command({ at_line = true }),
          },
        },
        theme = {
          activeBorderColor = { fg = "WarningMsg", bold = true },
        },
      },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
        },
        icons = {
          kinds = icons.kinds,
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    on_setup = function()
      map_keys({
        -- Smart picker
        {
          "<leader><space>",
          function()
            Snacks.picker.smart()
          end,
          desc = "Smart Find Files",
        },
        -- Explorer
        {
          "<leader>e",
          function()
            Snacks.explorer()
          end,
          desc = "File Explorer",
        },
        -- find
        {
          "<leader>fb",
          function()
            Snacks.picker.buffers({
              confirm = function(picker, item)
                picker:close()
                if not item then
                  return
                end
                -- If the buffer is already shown in a window (any tab),
                -- jump to that window instead of opening it here.
                vim.schedule(function()
                  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
                    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                      if vim.api.nvim_win_get_buf(win) == item.buf then
                        vim.api.nvim_set_current_tabpage(tab)
                        vim.api.nvim_set_current_win(win)
                        return
                      end
                    end
                  end
                  vim.api.nvim_set_current_buf(item.buf)
                end)
              end,
            })
          end,
          desc = "Buffers",
        },
        {
          "<leader>fc",
          function()
            Snacks.picker.files({ cwd = vim.env.HOME .. "/nixmania" })
          end,
          desc = "Find Config File",
        },
        {
          "<leader>ff",
          function()
            Snacks.picker.files()
          end,
          desc = "Find Files",
        },
        {
          "<leader>fg",
          function()
            Snacks.picker.git_files()
          end,
          desc = "Find Git Files",
        },
        {
          "<leader>fp",
          function()
            Snacks.picker.projects()
          end,
          desc = "Projects",
        },
        {
          "<leader>fr",
          function()
            Snacks.picker.recent()
          end,
          desc = "Recent",
        },
        -- git
        {
          "<leader>gb",
          function()
            Snacks.picker.git_branches()
          end,
          desc = "Git Branches",
        },
        {
          "<leader>gl",
          function()
            Snacks.picker.git_log()
          end,
          desc = "Git Log",
        },
        {
          "<leader>gL",
          function()
            Snacks.picker.git_log_line()
          end,
          desc = "Git Log Line",
        },
        {
          "<leader>gs",
          function()
            Snacks.picker.git_status()
          end,
          desc = "Git Status",
        },
        {
          "<leader>gS",
          function()
            Snacks.picker.git_stash()
          end,
          desc = "Git Stash",
        },
        {
          "<leader>gd",
          function()
            Snacks.picker.git_diff()
          end,
          desc = "Git Diff (Hunks)",
        },
        {
          "<leader>gf",
          function()
            Snacks.picker.git_log_file()
          end,
          desc = "Git Log File",
        },
        -- gh
        {
          "<leader>gi",
          function()
            Snacks.picker.gh_issue()
          end,
          desc = "GitHub Issues (open)",
        },
        {
          "<leader>gI",
          function()
            Snacks.picker.gh_issue({ state = "all" })
          end,
          desc = "GitHub Issues (all)",
        },
        {
          "<leader>gp",
          function()
            Snacks.picker.gh_pr()
          end,
          desc = "GitHub Pull Requests (open)",
        },
        {
          "<leader>gP",
          function()
            Snacks.picker.gh_pr({ state = "all" })
          end,
          desc = "GitHub Pull Requests (all)",
        },
        -- Grep
        {
          "<leader>sb",
          function()
            Snacks.picker.lines()
          end,
          desc = "Buffer Lines",
        },
        {
          "<leader>sB",
          function()
            Snacks.picker.grep_buffers()
          end,
          desc = "Grep Open Buffers",
        },
        {
          "<leader>sg",
          function()
            Snacks.picker.grep()
          end,
          desc = "Grep",
        },
        {
          "<leader>sw",
          function()
            Snacks.picker.grep_word()
          end,
          desc = "Visual selection or word",
          mode = { "n", "x" },
        },
        -- search
        {
          '<leader>s"',
          function()
            Snacks.picker.registers()
          end,
          desc = "Registers",
        },
        {
          "<leader>s/",
          function()
            Snacks.picker.search_history()
          end,
          desc = "Search History",
        },
        {
          "<leader>sa",
          function()
            Snacks.picker.autocmds()
          end,
          desc = "Autocmds",
        },
        {
          "<leader>sb",
          function()
            Snacks.picker.lines()
          end,
          desc = "Buffer Lines",
        },
        {
          "<leader>sc",
          function()
            Snacks.picker.command_history()
          end,
          desc = "Command History",
        },
        {
          "<leader>sC",
          function()
            Snacks.picker.commands()
          end,
          desc = "Commands",
        },
        {
          "<leader>sd",
          function()
            Snacks.picker.diagnostics()
          end,
          desc = "Diagnostics",
        },
        {
          "<leader>sD",
          function()
            Snacks.picker.diagnostics_buffer()
          end,
          desc = "Buffer Diagnostics",
        },
        {
          "<leader>sh",
          function()
            Snacks.picker.help()
          end,
          desc = "Help Pages",
        },
        {
          "<leader>sH",
          function()
            Snacks.picker.highlights()
          end,
          desc = "Highlights",
        },
        {
          "<leader>si",
          function()
            Snacks.picker.icons()
          end,
          desc = "Icons",
        },
        {
          "<leader>sj",
          function()
            Snacks.picker.jumps()
          end,
          desc = "Jumps",
        },
        {
          "<leader>sk",
          function()
            Snacks.picker.keymaps()
          end,
          desc = "Keymaps",
        },
        {
          "<leader>sl",
          function()
            Snacks.picker.loclist()
          end,
          desc = "Location List",
        },
        {
          "<leader>sm",
          function()
            Snacks.picker.marks()
          end,
          desc = "Marks",
        },
        {
          "<leader>sM",
          function()
            Snacks.picker.man()
          end,
          desc = "Man Pages",
        },
        {
          "<leader>sp",
          plugin_picker,
          desc = "Search for Plugin Spec",
        },
        {
          "<leader>sq",
          function()
            Snacks.picker.qflist()
          end,
          desc = "Quickfix List",
        },
        {
          "<leader>sR",
          function()
            Snacks.picker.resume()
          end,
          desc = "Resume",
        },
        {
          "<leader>st",
          function()
            Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
          end,
          desc = "Todo/Fix/Fixme",
        },
        {
          "<leader>su",
          function()
            Snacks.picker.undo()
          end,
          desc = "Undo History",
        },
        -- UI
        {
          "<leader>uh",
          function()
            Snacks.notifier.show_history()
          end,
          desc = "Notification History",
        },
        {
          "<leader>un",
          function()
            Snacks.notifier.hide()
          end,
          desc = "Dismiss All Notifications",
        },
        {
          "<leader>uC",
          function()
            Snacks.picker.colorschemes()
          end,
          desc = "Colorschemes",
        },
        -- Other
        {
          "<leader>z",
          function()
            Snacks.zen()
          end,
          desc = "Toggle Zen Mode",
        },
        {
          "<leader>Z",
          function()
            Snacks.zen.zoom()
          end,
          desc = "Toggle Zoom",
        },
        {
          "<leader>.",
          function()
            Snacks.scratch()
          end,
          desc = "Toggle Scratch Buffer",
        },
        {
          "<leader>S",
          function()
            Snacks.scratch.select()
          end,
          desc = "Select Scratch Buffer",
        },
        {
          "<leader>gB",
          function()
            Snacks.gitbrowse()
          end,
          desc = "Git Browse",
          mode = { "n", "v" },
        },
        {
          "<leader>gg",
          function()
            require("bugs.utils.lazygit").open()
          end,
          desc = "Lazygit",
        },
        {
          "<c-/>",
          function()
            Snacks.terminal()
          end,
          desc = "Toggle Terminal",
        },
        {
          "<c-_>",
          function()
            Snacks.terminal()
          end,
          desc = "which_key_ignore",
        },
      })
      -- Toggles
      Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.line_number():map("<leader>ul")
      Snacks.toggle.treesitter():map("<leader>uT")
      Snacks.toggle.dim():map("<leader>uD")
    end,
  },
  -- Lualine: Beautiful statusline
  {
    src = "nvim-lualine/lualine.nvim",
    opts = function()
      return {
        options = {
          theme = dofile(vim.fn.stdpath("config") .. "/colors/stylix-lualine-theme.lua"),
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
          refresh = {
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorMoved",
              "CursorMovedI",
              "ModeChanged",
              "RecordingEnter",
              "RecordingLeave",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            lualine_utils.root_dir(),
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            lualine_utils.pretty_path({ length = 0 }),
          },
          lualine_x = {
            Snacks.profiler.status(),
            lualine_utils.macro_recording(),
            lualine_utils.search_count(),
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.ERROR,
                warn = icons.diagnostics.WARN,
                info = icons.diagnostics.INFO,
                hint = icons.diagnostics.HINT,
              },
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1 } },
            { "location", padding = { right = 1 } },
          },
          lualine_z = {
            { lualine_utils.pretty_time(), padding = { left = 1, right = 1 } },
          },
        },
        extensions = { "quickfix" },
      }
    end,
  },
  -- Tiny cmdline: Floating commandline
  {
    src = "rachartier/tiny-cmdline.nvim",
    opts = {
      width = {
        value = "40%",
        min = 30,
        max = 50,
      },
      position = {
        y = "20%",
      },
      title = {
        enabled = true,
        pos = "center",
      },
    },
  },
  -- Incline: A nice floating statusline
  {
    src = "b0o/incline.nvim",
    opts = {
      window = {
        margin = { vertical = 0, horizontal = 1 },
        zindex = 60,
      },
      hide = {
        cursorline = "smart",
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if vim.bo[props.buf].modified then
          filename = "[+] " .. filename
        end

        local icon, hl = MiniIcons.get("file", filename)
        return { { icon, group = hl }, { " " }, { filename } }
      end,
    },
  },
})
