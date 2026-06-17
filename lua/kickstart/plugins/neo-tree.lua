-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local plugins = {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

if vim.g.have_nerd_font then
  table.insert(plugins, 'https://github.com/nvim-tree/nvim-web-devicons') -- not strictly required, but recommended
end

vim.pack.add(plugins)

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle file [E]xplorer', silent = true })

require('neo-tree').setup {
  window = {
    position = 'float',
    popup = {
      size = { height = '80%', width = '40%' },
      position = '50%',
    },
    mappings = {
      ['\\'] = 'close_window',
      ['<Esc>'] = 'close_window',
    },
  },
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
        ['<Esc>'] = 'close_window',
      },
    },
  },
}
