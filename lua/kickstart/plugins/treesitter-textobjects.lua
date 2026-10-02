-- Jump/select by function or class, handy on Odoo's long models.py files.

vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' }

require('nvim-treesitter-textobjects').setup {
  select = { lookahead = true },
  move = { set_jumps = true },
}

local select = require 'nvim-treesitter-textobjects.select'
vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end, { desc = 'around function' })
vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end, { desc = 'inside function' })
vim.keymap.set({ 'x', 'o' }, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end, { desc = 'around class' })
vim.keymap.set({ 'x', 'o' }, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end, { desc = 'inside class' })

local move = require 'nvim-treesitter-textobjects.move'
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end, { desc = 'Next function start' })
vim.keymap.set({ 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end, { desc = 'Next class start' })
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'Previous function start' })
vim.keymap.set({ 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end, { desc = 'Previous class start' })
