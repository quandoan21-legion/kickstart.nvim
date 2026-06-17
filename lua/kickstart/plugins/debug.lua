-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/leoluz/nvim-dap-go',
  'https://github.com/mfussenegger/nvim-dap-python',
}

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F10>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end, { desc = 'Debug: Re-run [L]ast session' })
vim.keymap.set('n', '<leader>cb', function()
  require('dap').clear_breakpoints()
  vim.notify('Cleared all breakpoints', vim.log.levels.INFO)
end, { desc = 'Debug: [C]lear all [B]reakpoints' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: Toggle DAP UI' })
vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, { desc = 'Debug: Toggle [D]AP [U]I' })

local dap = require 'dap'
local dapui = require 'dapui'

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
    'delve', -- Go debugger
    'python', -- installs debugpy for Python
  },
}

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
---@diagnostic disable-next-line: missing-fields
dapui.setup {
  -- Set icons to characters that are more likely to work in every terminal.
  --    Feel free to remove or use ones that you like more! :)
  --    Don't feel like these are good choices.
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  ---@diagnostic disable-next-line: missing-fields
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

-- Python DAP: uses debugpy installed by mason
local debugpy_python = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
require('dap-python').setup(debugpy_python)

-- Odoo-specific Python debug configurations
local dap_python_configs = require('dap').configurations.python or {}

table.insert(dap_python_configs, {
  type = 'python',
  request = 'launch',
  name = 'Odoo 18 base',
  program = '/Users/quandoan/Desktop/odoo-18.0/odoo-bin',
  pythonPath = '/usr/local/bin/python3.12',
  args = { '-c', 'debian/odoo-base.conf', '-d', 'base-1', '--xmlrpc-port', '9999' },
  justMyCode = false,
  env = { PYTHONPATH = '/Users/quandoan/Desktop/odoo-18.0' },
})

table.insert(dap_python_configs, {
  type = 'python',
  request = 'launch',
  name = 'Odoo 19 base',
  program = '/Users/quandoan/Desktop/odoo19/odoo-bin',
  pythonPath = '/Users/quandoan/Desktop/odoo19/.venv1/bin/python',
  args = { '-c', 'debian/odoo.conf', '-u', 'a1_purchase_custom' },
  justMyCode = false,
  env = { PYTHONPATH = '/Users/quandoan/Desktop/odoo19' },
})

table.insert(dap_python_configs, {
  type = 'python',
  request = 'launch',
  name = 'Odoo 18 Tayoong',
  program = '/Users/quandoan/Desktop/odoo-18.0/odoo-bin',
  pythonPath = '/usr/local/bin/python3.12',
  args = { '-c', 'debian/odoo-tayoong.conf', '-u', 'a1_einvoice_to_gov', '--xmlrpc-port', '8069' },
  justMyCode = false,
  env = { PYTHONPATH = '/Users/quandoan/Desktop/odoo-18.0' },
})

table.insert(dap_python_configs, {
  type = 'python',
  request = 'launch',
  name = 'Odoo 18 E-invoice',
  program = '/Users/quandoan/Desktop/odoo-18.0/odoo-bin',
  pythonPath = '/usr/local/bin/python3.12',
  args = {
    '-c', 'debian/odoo-e-invoice.conf',
    '-u', 'a1_einvoice_to_gov,tayoong_issue_consolidate_invoice,issue_consolidate_invoice',
    '--xmlrpc-port', '8099',
  },
  justMyCode = false,
  env = { PYTHONPATH = '/Users/quandoan/Desktop/odoo-18.0' },
})

table.insert(dap_python_configs, {
  type = 'python',
  request = 'launch',
  name = 'Odoo 19 HMV-PACKAGE',
  program = '/Users/quandoan/Desktop/odoo19/odoo-bin',
  pythonPath = '/Users/quandoan/Desktop/odoo19/.venv1/bin/python',
  args = { '-c', '/Users/quandoan/Desktop/HMV-PACKAGE/odoo.conf' },
  justMyCode = false,
  env = { PYTHONPATH = '/Users/quandoan/Desktop/odoo19' },
})

require('dap').configurations.python = dap_python_configs
