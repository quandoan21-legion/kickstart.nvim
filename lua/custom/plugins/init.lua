-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'tpope/vim-dadbod',
    config = function()
      -- Optional configuration for vim-dadbod, if needed
    end,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    config = function()
      -- Optional configuration for vim-dadbod-ui, if needed
    end,
  },
  -- {
  --   'Pocco81/auto-save.nvim',
  -- },
  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    config = function()
      require('smear_cursor').setup {
        cursor_color = '#ff8800',
        stiffness = 1,
        trailing_stiffness = 0.35,
        trailing_exponent = 15,
        hide_target_hack = false,
        gamma = 1,
      }
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        transparent = true,
      }
      vim.cmd 'colorscheme tokyonight'
    end,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      local dap = require 'dap'
      local dap_python = require 'dap-python'
      local dapui = require 'dapui'

      local debugpy_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
      dap_python.setup(debugpy_path)

      dap.configurations.python = dap.configurations.python or {}
      table.insert(dap.configurations.python, {
        type = 'python',
        name = 'Odoo Cesiot',
        request = 'launch',
        program = '/Users/quandoan/Desktop/odoo-18.0/odoo-bin',
        args = {
          '-c',
          '/Users/quandoan/Desktop/odoo-18.0-copy/debian/odoo-tayoong.conf',
          '-u',
          'a1_einvoice_to_gov,cesiot_issue_consolidate_invoice',
          '-d',
          'cesiot',
          '--xml-rpc-port',
          '8999',
        },
        pythonPath = function()
          return '/usr/local/bin/python3.12'
        end,
        cwd = vim.fn.getcwd(),
        env = { PYTHONUNBUFFERED = '1' },
        console = 'integratedTerminal',
      })

      -- Ta-yoong project debug config
      table.insert(dap.configurations.python, {
        type = 'python',
        name = 'Odoo Tayoong',
        request = 'launch',
        program = '/Users/quandoan/Desktop/odoo-18.0/odoo-bin',
        args = {
          '-c',
          '/Users/quandoan/Desktop/odoo-18.0/debian/odoo-tayoong.conf',
          '-u',
          'a1_einvoice_to_gov,tayoong_issue_consolidate_invoice',
          '-d',
          'tayoong',
          -- '-i',
          -- 'base',
        },
        pythonPath = function()
          return '/usr/local/bin/python3.12'
        end,
        cwd = vim.fn.getcwd(),
        env = { PYTHONUNBUFFERED = '1' },
        console = 'integratedTerminal',
      })
      -- odoo 13 debug
      table.insert(dap.configurations.python, {
        name = 'Odoo 13',
        type = 'python',
        request = 'launch',
        program = '/Users/quandoan/Desktop/odoo-13.0/odoo-bin',
        args = {
          '-c',
          '/Users/quandoan/Desktop/odoo-13.0/debian/odoo.conf',
          '--limit-memory-hard',
          '0',
          '-u',
          'a1_einvoice_to_gov',
        },
        pythonPath = function()
          return '/usr/local/bin/pvenv3.7'
        end,
        cwd = vim.fn.getcwd(),
        env = { PYTHONUNBUFFERED = '1' },
        console = 'integratedTerminal',
      })

      -- UI signs
      vim.fn.sign_define('DapBreakpoint', { text = 'B', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', { text = 'C', texthl = 'DapBreakpointCondition' })
      vim.fn.sign_define('DapStopped', { text = '>', texthl = 'DapStopped', linehl = 'CursorLine' })

      vim.cmd [[
        highlight DapBreakpoint guifg=#FFA500 guibg=#1F1F28
        highlight DapBreakpointCondition guifg=#FFA500 guibg=#1F1F28
        highlight DapStopped guifg=#FFA500 guibg=#1F1F28
      ]]

      dapui.setup {
        layouts = {
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 0.15,
            position = 'left',
          },
          {
            elements = {
              { id = 'scopes', size = 1.0 },
            },
            size = 0.85,
            position = 'bottom',
          },
        },
      }
    end,
  },
}
