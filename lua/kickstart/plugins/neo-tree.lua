-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
        ['yy'] = 'copy_absolute_path_to_clipboard',
        ['yn'] = 'copy_name_to_clipboard',
        ['yr'] = 'copy_relative_path_to_clipboard',
      },
    },
  },
  commands = {
    copy_absolute_path_to_clipboard = function(state)
      local node = state.tree:get_node()
      vim.fn.setreg('+', node.path)
      vim.notify('Copied absolute path: ' .. node.path)
    end,
    copy_name_to_clipboard = function(state)
      local node = state.tree:get_node()
      vim.fn.setreg('+', node.name)
      vim.notify('Copied name: ' .. node.name)
    end,
    copy_relative_path_to_clipboard = function(state)
      local node = state.tree:get_node()
      local relative_path = vim.fn.fnamemodify(node.path, ':.')
      vim.fn.setreg('+', relative_path)
      vim.notify('Copied relative path: ' .. relative_path)
    end,
  },
}
