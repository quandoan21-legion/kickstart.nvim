-- debug.lua
--
-- DAP setup, configured for debugging Odoo 19 (Python) via debugpy.

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/mfussenegger/nvim-dap-python',
}

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: See last session result.' })
vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, { desc = 'Debug: Toggle UI' })
vim.keymap.set('n', '<leader>DL', function() require('dap').restart() end, { desc = 'Debug: Reload/Restart running session' })

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
    'debugpy',
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
  layouts = {
    {
      elements = {
        { id = 'breakpoints', size = 0.33 },
        { id = 'stacks', size = 0.34 },
        { id = 'repl', size = 0.33 },
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        'scopes',
      },
      size = 10,
      position = 'bottom',
    },
  },
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
vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#ff3c3c', bold = true })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffd633', bold = true })
-- Highlight for the line the debugger is currently stopped on.
vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#3d3415' })
local breakpoint_icons = vim.g.have_nerd_font
    and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
  or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
for type, icon in pairs(breakpoint_icons) do
  local tp = 'Dap' .. type
  local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
  vim.fn.sign_define(tp, {
    text = icon,
    texthl = hl,
    numhl = hl,
    linehl = (type == 'Stopped') and 'DapStoppedLine' or nil,
  })
end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Python / Odoo 19 debugging config
--
-- odoo-19.0/.venv already has psycopg2 + debugpy installed, and
-- odoo-19.0/odoo.conf points at the local Postgres role "quandoan".
local odoo_dir = vim.fn.expand '~/Desktop/odoo-19.0'
local odoo_python = odoo_dir .. '/.venv/bin/python'

require('dap-python').setup(odoo_python)

dap.configurations.python = dap.configurations.python or {}
table.insert(dap.configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'Odoo 19 (odoo-bin)',
  program = odoo_dir .. '/odoo-bin',
  pythonPath = function() return odoo_python end,
  cwd = odoo_dir,
  console = 'integratedTerminal',
  args = { '-c', odoo_dir .. '/odoo.conf', '--dev=all' },
})

-- Python / HMV-PACKAGE debugging config
--
-- HMV-PACKAGE (gitlab.arrowhitech.co:BC6/HMV-PACKAGE) is a client addons repo, not a
-- full Odoo checkout: it has no odoo-bin of its own, so we run it against the local
-- odoo-19.0 core, with its bundled enterprise/community/a1_packages/project_custom
-- addons layered on via addons_path. The local conf lives alongside odoo-19.0's own
-- odoo.conf (not inside HMV-PACKAGE) so both configs share one place.
local hmv_dir = vim.fn.expand '~/Desktop/HMV-PACKAGE'
local hmv_conf = odoo_dir .. '/odoo.hmv.local.conf'

-- Modules passed to `-u`. Stays fixed across runs until you explicitly change it
-- with <leader>Dm — debugging doesn't re-prompt on every launch.
local hmv_modules = 'hmv_employee_resignation,hmv_employee_resignation_workflow'

-- Every addons dir on the HMV-PACKAGE odoo.conf's addons_path, so the picker only
-- offers modules that `-u` could actually resolve.
local hmv_addons_paths = {
  odoo_dir .. '/addons',
  hmv_dir .. '/addons/enterprise',
  hmv_dir .. '/addons/community',
  hmv_dir .. '/addons/a1_packages',
  hmv_dir .. '/addons/project_custom',
}

local function list_hmv_modules()
  local modules = {}
  for _, path in ipairs(hmv_addons_paths) do
    local ok, entries = pcall(vim.fs.dir, path)
    if ok then
      for name, ftype in entries do
        if ftype == 'directory' and vim.uv.fs_stat(path .. '/' .. name .. '/__manifest__.py') then table.insert(modules, name) end
      end
    end
  end
  table.sort(modules)
  return modules
end

local function pick_hmv_modules()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local telescope_conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({}, {
      prompt_title = 'HMV-PACKAGE modules to update (-u)  <Tab> select  <CR> confirm',
      finder = finders.new_table { results = list_hmv_modules() },
      sorter = telescope_conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          local multi = picker:get_multi_selection()
          local chosen = {}
          if #multi > 0 then
            for _, entry in ipairs(multi) do
              table.insert(chosen, entry.value)
            end
          else
            local entry = action_state.get_selected_entry()
            if entry then table.insert(chosen, entry.value) end
          end
          actions.close(prompt_bufnr)
          if #chosen == 0 then return end
          table.sort(chosen)
          hmv_modules = table.concat(chosen, ',')
          vim.notify('HMV-PACKAGE modules to update: ' .. hmv_modules)
        end)
        return true
      end,
    })
    :find()
end

vim.keymap.set('n', '<leader>Dm', pick_hmv_modules, { desc = 'Debug: Pick HMV-PACKAGE modules (-u)' })

table.insert(dap.configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'HMV-PACKAGE (odoo-bin)',
  program = odoo_dir .. '/odoo-bin',
  pythonPath = function() return odoo_python end,
  cwd = hmv_dir,
  console = 'integratedTerminal',
  args = function() return { '-c', hmv_conf, '-u', hmv_modules, '--dev=all' } end,
})
