-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    dap.configurations.python = dap.configurations.python or {}

    -- Odoo 18 (Tayoong)
    table.insert(dap.configurations.python, {
      name = 'Odoo Tayoong 8669',
      type = 'python',
      request = 'launch',
      program = '/Users/quandoan/Desktop/odoo-18.0/odoo-bin',
      args = {
        '-c',
        '/Users/quandoan/Desktop/odoo-18.0/debian/odoo-tayoong.conf',
        '-u',
        'a1_einvoice_to_gov',
        '-i',
        'base',
        '-d',
        'tayoong-12',
        '--xmlrpc-port',
        '8669',
      },
      pythonPath = function()
        return '/usr/local/bin/python3.12'
      end,
      cwd = vim.fn.getcwd(),
      env = { PYTHONUNBUFFERED = '1' },
      console = 'integratedTerminal',
    })

    -- Odoo 13
    table.insert(dap.configurations.python, {
      name = 'Odoo 13',
      type = 'python',
      request = 'launch',
      program = '/Users/quandoan/Desktop/odoo-13.0/odoo-bin',
      args = {
        '-c',
        '/Users/quandoan/Desktop/odoo-13.0/debian/odoo.conf',
        '-u',
        'a1_einvoice_to_gov',
        '--xmlrpc-port',
        '8066',
      },
      pythonPath = function()
        return '/usr/local/bin/python3.7'
      end,
      cwd = vim.fn.getcwd(),
      env = { PYTHONUNBUFFERED = '1' },
      console = 'integratedTerminal',
    })
    vim.cmd [[
      highlight DapBreakpoint guifg=#FF8800 guibg=#1E1E2E
      highlight DapBreakpointCondition guifg=#F1FA8C guibg=#1E1E2E
      highlight DapStopped guifg=#50FA7B guibg=#1E1E2E
    ]]

    vim.fn.sign_define('DapBreakpoint', {
      text = '●',
      texthl = 'DapBreakpoint',
      linehl = '',
      numhl = '',
    })

    vim.fn.sign_define('DapBreakpointCondition', {
      text = '◆',
      texthl = 'DapBreakpointCondition',
      linehl = '',
      numhl = '',
    })

    vim.fn.sign_define('DapStopped', {
      text = '▶',
      texthl = 'DapStopped',
      linehl = '',
      numhl = '',
    })
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'python',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      layouts = {
        {
          elements = {
            { id = 'console', size = 1.5 },
          },
          size = 0.15,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'scopes', size = 0.5 },
          },
          size = 0.5,
          position = 'bottom',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
