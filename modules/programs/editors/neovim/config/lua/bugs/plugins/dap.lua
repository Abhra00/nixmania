-- Import the package manager wrapper functions
local add_on_file_type = Utils.vim_pack.add_on_file_type

-- Import the helper function for setting keymaps
local map_keys = Utils.map.map_keys

-- Import the needed icons
local icons = Utils.icons

-- Port the osv server listens on
local osv_port = 8086

add_on_file_type("lua", {
  -- Nvim nio: Async library required by nvim-dap-ui
  { src = "nvim-neotest/nvim-nio", setup = false },

  -- Nvim dap: Debug adapter protocol client
  {
    src = "mfussenegger/nvim-dap",
    module_name = "dap",
    on_setup = function()
      local dap = require("dap")

      -- Lua adapter: attach to a Neovim instance running the osv server
      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or osv_port })
      end
      dap.configurations.lua = {
        { type = "nlua", request = "attach", name = "Attach to running Neovim instance" },
      }

      -- Gutter signs, the colors come from the colorscheme
      for name, icon in pairs(icons.dap) do
        local line_hl = name == "Stopped" and "DapStoppedLine" or nil
        vim.fn.sign_define("Dap" .. name, {
          text = icon .. " ",
          texthl = "Dap" .. name,
          linehl = line_hl,
          numhl = line_hl,
        })
      end

      map_keys({
        {
          "<leader>db",
          function()
            dap.toggle_breakpoint()
          end,
          desc = "Toggle breakpoint",
        },
        {
          "<leader>dB",
          function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Conditional breakpoint",
        },
        {
          "<leader>dx",
          function()
            dap.clear_breakpoints()
          end,
          desc = "Clear all breakpoints",
        },
        {
          "<leader>dc",
          function()
            dap.continue()
          end,
          desc = "Continue / attach",
        },
        {
          "<leader>di",
          function()
            dap.step_into()
          end,
          desc = "Step into",
        },
        {
          "<leader>do",
          function()
            dap.step_over()
          end,
          desc = "Step over",
        },
        {
          "<leader>dO",
          function()
            dap.step_out()
          end,
          desc = "Step out",
        },
        {
          "<leader>dC",
          function()
            dap.run_to_cursor()
          end,
          desc = "Run to cursor",
        },
        {
          "<leader>dt",
          function()
            dap.terminate()
          end,
          desc = "Terminate session",
        },
        {
          "<leader>dl",
          function()
            require("osv").launch({ port = osv_port })
          end,
          desc = "Launch Lua debuggee",
        },
        {
          "<leader>dL",
          function()
            require("osv").launch({ port = osv_port, blocking = true })
          end,
          desc = "Launch Lua debuggee (wait for client)",
        },
        {
          "<leader>dq",
          function()
            require("osv").stop()
          end,
          desc = "Stop Lua debuggee",
        },
        { "<F5>", dap.continue, desc = "Debug: Continue / attach" },
        { "<F9>", dap.toggle_breakpoint, desc = "Debug: Toggle breakpoint" },
        { "<F10>", dap.step_over, desc = "Debug: Step over" },
        { "<F11>", dap.step_into, desc = "Debug: Step into" },
        { "<S-F11>", dap.step_out, desc = "Debug: Step out" },
      })
    end,
  },
  -- One small step for vimkind: The Lua debug adapter
  { src = "jbyuki/one-small-step-for-vimkind", setup = false },

  -- Nvim dap ui: Scopes, stacks, watches and repl windows
  {
    src = "rcarriga/nvim-dap-ui",
    module_name = "dapui",
    opts = {
      icons = {
        expanded = icons.arrows.down,
        collapsed = icons.arrows.right,
        current_frame = icons.arrows.right,
      },
      floating = { border = "rounded" },
      layouts = {
        {
          position = "left",
          size = 40,
          elements = {
            { id = "scopes", size = 0.45 },
            { id = "breakpoints", size = 0.15 },
            { id = "stacks", size = 0.2 },
            { id = "watches", size = 0.2 },
          },
        },
        {
          position = "bottom",
          size = 10,
          elements = { { id = "repl", size = 1 } },
        },
      },
    },
    on_setup = function()
      local dap, dapui = require("dap"), require("dapui")

      -- Open the ui when a session starts, close it when it ends
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      map_keys({
        {
          "<leader>du",
          function()
            dapui.toggle()
          end,
          desc = "Toggle debug ui",
        },
        {
          "<leader>de",
          function()
            dapui.eval(nil, { enter = true })
          end,
          mode = { "n", "x" },
          desc = "Evaluate expression",
        },
      })
    end,
  },
})
