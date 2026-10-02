-- Side-by-side (3-way) diff / merge-conflict resolution.
-- `:DiffviewOpen` during an active merge/rebase auto-opens the merge-tool
-- layout (OURS | MERGED | THEIRS, side by side). Inside that view:
--   <leader>co / ct / cb / ca  - choose ours/theirs/base/all for this conflict
--   <leader>cO / cT / cB / cA  - same, but for the whole file
--   ]x / [x                   - jump to next/previous conflict
--   dx                        - delete this conflict region
-- (git-conflict.lua's bare co/ct/cb/c0 keep working inline on a normal buffer;
-- these leader-prefixed ones only apply inside Diffview's own panes.)

vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

require('diffview').setup {}

vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = '[G]it [d]iff / merge tool' })
vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewClose<CR>', { desc = '[G]it close [D]iffview' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<CR>', { desc = '[G]it file [H]istory' })
