-- Floating/split terminal for quick `odoo-bin shell`, git, psql, docker, etc.
-- without leaving Neovim.

vim.pack.add { 'https://github.com/akinsho/toggleterm.nvim' }

require('toggleterm').setup {
  size = 15,
  open_mapping = [[<C-t>]],
  direction = 'float',
  float_opts = { border = 'curved' },
  shade_terminals = true,
}

vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = '[T]oggle [T]erminal' })
vim.keymap.set('t', '<C-t>', [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = 'Toggle terminal' })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
