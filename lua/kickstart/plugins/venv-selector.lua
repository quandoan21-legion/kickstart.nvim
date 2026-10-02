-- Quickly switch which Python venv basedpyright/dap use. Useful since Odoo
-- core, HMV-PACKAGE, and future client projects may share or differ on venvs.

vim.pack.add { 'https://github.com/linux-cultist/venv-selector.nvim' }

require('venv-selector').setup {
  settings = {
    search = {
      -- Always offer every venv under ~/Desktop, regardless of the current cwd
      -- (HMV-PACKAGE has no venv of its own; it reuses odoo-19.0's).
      desktop_venvs = {
        command = "fd '/bin/python$' " .. vim.fn.expand '~/Desktop' .. " --full-path --color never -IH -E '/proc/*'",
      },
    },
  },
}

vim.keymap.set('n', '<leader>cv', '<cmd>VenvSelect<CR>', { desc = '[C]ode: select [V]env' })
