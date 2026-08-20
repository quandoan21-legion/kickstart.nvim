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

-- Resolves the node currently selected in neo-tree to an absolute directory.
-- Files resolve to their parent dir; folders resolve to themselves.
-- Returns nil (and notifies) if neo-tree isn't open or has no selection.
local function get_selected_dir()
  local manager_ok, manager = pcall(require, 'neo-tree.sources.manager')
  if not manager_ok then return nil end
  local state = manager.get_state 'filesystem'
  if not state or not state.tree then
    vim.notify('Neo-tree filesystem source is not open', vim.log.levels.WARN)
    return nil
  end
  local node = state.tree:get_node()
  if not node then
    vim.notify('No node selected in Neo-tree', vim.log.levels.WARN)
    return nil
  end
  if node.type == 'directory' then return node.path end
  return vim.fn.fnamemodify(node.path, ':h')
end

-- <leader>yy: pick a path format for the selected neo-tree node and copy it
-- to both the system clipboard (+) and unnamed (") registers.
vim.keymap.set('n', '<leader>yy', function()
  local manager_ok, manager = pcall(require, 'neo-tree.sources.manager')
  if not manager_ok then return end
  local state = manager.get_state 'filesystem'
  if not state or not state.tree then
    vim.notify('Neo-tree filesystem source is not open', vim.log.levels.WARN)
    return
  end
  local node = state.tree:get_node()
  if not node then
    vim.notify('No node selected in Neo-tree', vim.log.levels.WARN)
    return
  end

  vim.ui.select({ 'Absolute path', 'Relative path', 'Filename only' }, {
    prompt = 'Copy path as:',
  }, function(choice)
    if not choice then return end
    local value
    if choice == 'Absolute path' then
      value = node.path
    elseif choice == 'Relative path' then
      value = vim.fn.fnamemodify(node.path, ':.')
    else
      value = vim.fn.fnamemodify(node.path, ':t')
    end
    vim.fn.setreg('+', value)
    vim.fn.setreg('"', value)
    vim.notify('Copied (' .. choice .. '): ' .. value)
  end)
end, { desc = '[Y]ank neo-tree path (pick format)' })

-- <leader>fs / <leader>gs: Telescope find_files / live_grep scoped to the
-- directory currently selected in neo-tree (parent dir if a file is selected).
vim.keymap.set('n', '<leader>fs', function()
  local dir = get_selected_dir()
  if not dir then return end
  require('telescope.builtin').find_files {
    cwd = dir,
    prompt_title = 'Find Files: ' .. vim.fn.fnamemodify(dir, ':~'),
  }
end, { desc = '[F]ind files in neo-tree [S]elected dir' })

vim.keymap.set('n', '<leader>gs', function()
  local dir = get_selected_dir()
  if not dir then return end
  require('telescope.builtin').live_grep {
    cwd = dir,
    prompt_title = 'Live Grep: ' .. vim.fn.fnamemodify(dir, ':~'),
  }
end, { desc = '[G]rep in neo-tree [S]elected dir' })

require('neo-tree').setup {
  git_status_async = true,
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
        ['Y'] = 'copy_path_to_clipboard', -- absolute path
        ['<C-y>'] = function(state)
          local node = state.tree:get_node()
          local path = vim.fn.fnamemodify(node.path, ':.')
          vim.fn.setreg('+', path)
          vim.fn.setreg('"', path)
          vim.notify('Copied relative path: ' .. path)
        end,
        ['N'] = function(state)
          local node = state.tree:get_node()
          local name = vim.fn.fnamemodify(node.path, ':t')
          vim.fn.setreg('+', name)
          vim.fn.setreg('"', name)
          vim.notify('Copied name: ' .. name)
        end,
      },
    },
  },
}
