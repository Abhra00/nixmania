-- Import the package manager wrapper functions
local collect = Utils.vim_pack.collect

-- Import the helper function for setting keymaps
local map_keys = Utils.map.map_keys

-- Import the needed icons
local icons = Utils.icons

-- Import the utilities
local root_utils = Utils.root

-- Plugin picker: Lists installed plugins and browses their files (<M-p> returns to the list)
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

-- Snacks (picker): Finder, Git and GitHub pickers, file explorer, and fast file loading
collect({
  {
    src = "folke/snacks.nvim",
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          files = { hidden = false },
          grep = { hidden = false },
        },
        icons = { kinds = icons.kinds },
        win = {
          input = {
            keys = {
              ["<a-c>"] = { "toggle_cwd", mode = { "n", "i" } },
              ["<a-t>"] = { "trouble_open", mode = { "n", "i" } },
            },
          },
        },
        actions = {
          trouble_open = function(...)
            return require("trouble.sources.snacks").actions.trouble_open.action(...)
          end,
          toggle_cwd = function(p)
            local base = root_utils.get(p.input.filter.current_buf)
            local cwd = root_utils.cwd()
            p:set_cwd(p:cwd() == base and cwd or base)
            p:find()
          end,
        },
      },
      quickfile = { enabled = true },
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
        -- Find
        {
          "<leader>fb",
          function()
            Snacks.picker.buffers({
              confirm = function(picker, item)
                picker:close()
                if not item then
                  return
                end
                -- If the buffer is already shown in a window (any tab), jump to that window instead of opening it here
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
          "<leader>fB",
          function()
            Snacks.picker.buffers({ hidden = true, nofile = true })
          end,
          desc = "Buffers (all)",
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
            Snacks.picker.files({ cwd = root_utils.get() })
          end,
          desc = "Find Files (Root)",
        },
        {
          "<leader>fF",
          function()
            Snacks.picker.files()
          end,
          desc = "Find Files (cwd)",
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
        {
          "<leader>fR",
          function()
            Snacks.picker.recent({ filter = { cwd = true } })
          end,
          desc = "Recent (cwd)",
        },
        -- Git
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
        -- GitHub
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
            Snacks.picker.grep({ cwd = root_utils.get() })
          end,
          desc = "Grep (Root)",
        },
        {
          "<leader>sG",
          function()
            Snacks.picker.grep()
          end,
          desc = "Grep (cwd)",
        },
        {
          "<leader>sw",
          function()
            Snacks.picker.grep_word({ cwd = root_utils.get() })
          end,
          desc = "Visual selection or word (Root)",
          mode = { "n", "x" },
        },
        {
          "<leader>sW",
          function()
            Snacks.picker.grep_word()
          end,
          desc = "Visual selection or word (cwd)",
          mode = { "n", "x" },
        },
        -- Search
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
      })
    end,
  },
})
