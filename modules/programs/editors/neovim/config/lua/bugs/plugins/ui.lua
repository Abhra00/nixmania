-- Import the package manager wrapper functions
local add = Utils.vim_pack.add
local collect = Utils.vim_pack.collect
local flush = Utils.vim_pack.flush

-- Import the needed icons
local icons = Utils.icons

-- Import the utilities
local lualine_utils = Utils.lualine

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
})

-- Snacks (ui): Dashboard, notifier, indent guides, scrolling, toggles, and other UI modules
collect({
  {
    src = "folke/snacks.nvim",
    opts = {
      animate = { enabled = true },
      dashboard = {
        enabled = true,
        width = 62,
        preset = {
          header = require("bugs.utils.ascii-art"),
          keys = {
            {
              icon = "\u{f15b} ",
              key = "f",
              desc = "Find file",
              action = function()
                Snacks.picker.files()
              end,
            },
            {
              icon = "\u{f002} ",
              key = "g",
              desc = "Grep",
              action = function()
                Snacks.picker.grep()
              end,
            },
            {
              icon = "\u{f1da} ",
              key = "r",
              desc = "Recent",
              action = function()
                Snacks.picker.recent()
              end,
            },
            {
              icon = "\u{f013} ",
              key = "c",
              desc = "Config",
              action = function()
                Snacks.picker.files({ cwd = vim.env.HOME .. "/nixmania" })
              end,
            },
            { icon = "\u{f011} ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header", padding = 2 },
          { section = "keys", gap = 1, padding = 2 },
          function()
            local v = vim.version()
            return {
              align = "center",
              text = {
                { ("NVIM %d.%d.%d | BLAZIGLY FAST NVIM CONFIG"):format(v.major, v.minor, v.patch), hl = "footer" },
              },
            }
          end,
        },
      },
      image = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    on_setup = function()
      Utils.cursor_animate.setup()
      Utils.map.map_keys({
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
})

-- Set up Snacks now that all its specs are collected; lualine, configured below, uses Snacks at setup time
flush()

add({
  -- Lualine: Beautiful statusline
  {
    src = "nvim-lualine/lualine.nvim",
    opts = function()
      lualine_utils.animate_lsp_spinner()
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
            },
          },
        },
        sections = {
          lualine_a = {
            { "mode", padding = 1 },
          },
          lualine_b = {
            { "branch", icon = icons.git.branch, padding = 1 },
          },
          lualine_c = {
            {
              lualine_utils.root_dir({
                cwd = false,
                subdirectory = true,
                parent = true,
                other = true,
                icon = icons.misc.root_dir,
                hl = "LualineRootDir",
              }),
              padding = 1,
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic", "coc" },
              sections = { "error", "warn", "info", "hint" },
              colored = true,
              update_in_insert = false,
              always_visible = false,
              symbols = {
                error = icons.diagnostics.ERROR .. " ",
                warn = icons.diagnostics.WARN .. " ",
                info = icons.diagnostics.INFO .. " ",
                hint = icons.diagnostics.HINT .. " ",
              },
              padding = 1,
            },
            { "filetype", colored = true, icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            {
              lualine_utils.pretty_path({
                relative = "cwd",
                length = 0,
                directory_hl = "",
                filename_hl = "LualineFile",
                modified_hl = "LualineFileModified",
                modified_sign = "",
                readonly_hl = "LualineFileReadonlyIcon",
                readonly_icon = " " .. icons.misc.lock .. " ",
              }),
              padding = { left = 0, right = 1 },
            },
            lualine_utils.trouble_symbols(),
          },
          lualine_x = {
            Snacks.profiler.status(),
            {
              "lsp_status",
              icon = { icons.misc.gear, color = "LualineLspStatus" },
              symbols = {
                spinner = icons.spinner_icons,
                done = icons.done,
                separator = " ",
              },
              ignore_lsp = {},
              show_name = true,
              color = lualine_utils.lsp_status_color,
              padding = 1,
            },
            {
              lualine_utils.macro_recording({
                icon = icons.misc.recording,
                hl = "LualineMacroRecording",
              }),
              padding = 1,
            },
            {
              lualine_utils.search_count({
                icon = icons.misc.search,
                maxcount = 999,
                timeout = 500,
                hl = "LualineSearchCount",
              }),
              padding = 1,
            },
            {
              "diff",
              colored = true,
              symbols = {
                added = icons.git.added .. " ",
                modified = icons.git.modified .. " ",
                removed = icons.git.removed .. " ",
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
              padding = 1,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
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
  -- Which-key: Show hints for available keymaps
  {
    src = "folke/which-key.nvim",
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        mode = { "n", "x" },
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>l", group = "live preview", icon = { icon = "", hl = "WhichKeyIconOrange" } },
        { "<leader>p", group = "packages", icon = { icon = "󰏓", hl = "WhichKeyIconAzure" } },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>x", group = "quickfix/diagnostics" },
        { "<leader>y", group = "yank", icon = { icon = "󰅇", hl = "WhichKeyIconYellow" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
      },
    },
  },
})
