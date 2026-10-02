-- Highlights git merge-conflict markers and lets you resolve them without
-- leaving the buffer. Mappings below only activate in a buffer that actually
-- has conflict markers — they don't affect normal editing.

vim.pack.add { 'https://github.com/akinsho/git-conflict.nvim' }

require('git-conflict').setup {
  default_mappings = true, -- co: choose ours, ct: choose theirs, cb: choose both, c0: choose none
  default_commands = true, -- :GitConflictChooseOurs/Theirs/Both/None, :GitConflictListQf
  -- NOTE: git-conflict's own `disable_diagnostics` option still calls the
  -- removed `vim.diagnostic.disable()` API and crashes on Neovim 0.12, so we
  -- leave it off and reimplement the same behavior below via the plugin's own
  -- GitConflictDetected/GitConflictResolved events + the current API.
  disable_diagnostics = false,
  highlights = {
    incoming = 'DiffAdd',
    current = 'DiffText',
  },
}

-- Conflict markers break syntax (unclosed brackets, stray `<<<<<<<`, etc.), so
-- LSP/linter diagnostics are just noise until the conflict is resolved. Mute
-- them per-buffer while conflicted, restore once resolved.
local conflict_diag_augroup = vim.api.nvim_create_augroup('git-conflict-diagnostics', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = conflict_diag_augroup,
  pattern = 'GitConflictDetected',
  callback = function() vim.diagnostic.enable(false, { bufnr = vim.api.nvim_get_current_buf() }) end,
})
vim.api.nvim_create_autocmd('User', {
  group = conflict_diag_augroup,
  pattern = 'GitConflictResolved',
  callback = function() vim.diagnostic.enable(true, { bufnr = vim.api.nvim_get_current_buf() }) end,
})

-- ]x / [x jump between conflicts (plugin's own default_mappings also set these,
-- kept here explicitly in case default_mappings is ever turned off).
vim.keymap.set('n', ']x', '<cmd>GitConflictNextConflict<CR>', { desc = 'Next git conflict' })
vim.keymap.set('n', '[x', '<cmd>GitConflictPrevConflict<CR>', { desc = 'Previous git conflict' })

-- List every conflict in the repo (across files) in the quickfix list.
vim.keymap.set('n', '<leader>hc', '<cmd>GitConflictListQf<CR>', { desc = 'Git [c]onflicts to quickfix' })
