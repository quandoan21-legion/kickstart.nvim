-- Linting

vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' }, -- Make sure to install `markdownlint` via mason / npm
}

-- pylint + pylint-odoo live in the shared Odoo dev venv (see debug.lua), not on
-- $PATH, so point nvim-lint's bundled pylint linter at it directly.
lint.linters.pylint.cmd = vim.fn.expand '~/Desktop/odoo-19.0/.venv/bin/pylint'

-- To allow other plugins to add linters to require('lint').linters_by_ft,
-- instead set linters_by_ft like this:
-- lint.linters_by_ft = lint.linters_by_ft or {}
-- lint.linters_by_ft['markdown'] = { 'markdownlint' }
--
-- However, note that this will enable a set of default linters,
-- which will cause errors unless these tools are available:
-- {
--   clojure = { "clj-kondo" },
--   dockerfile = { "hadolint" },
--   inko = { "inko" },
--   janet = { "janet" },
--   json = { "jsonlint" },
--   markdown = { "vale" },
--   rst = { "vale" },
--   ruby = { "ruby" },
--   terraform = { "tflint" },
--   text = { "vale" }
-- }
--
-- You can disable the default linters by setting their filetypes to nil:
-- lint.linters_by_ft['clojure'] = nil
-- lint.linters_by_ft['dockerfile'] = nil
-- lint.linters_by_ft['inko'] = nil
-- lint.linters_by_ft['janet'] = nil
-- lint.linters_by_ft['json'] = nil
-- lint.linters_by_ft['markdown'] = nil
-- lint.linters_by_ft['rst'] = nil
-- lint.linters_by_ft['ruby'] = nil
-- lint.linters_by_ft['terraform'] = nil
-- lint.linters_by_ft['text'] = nil

-- Create autocommand which carries out the actual linting
-- on the specified events.
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only run the linter in buffers that you can modify in order to
    -- avoid superfluous noise, notably within the handy LSP pop-ups that
    -- describe the hovered symbol using Markdown.
    if vim.bo.modifiable then lint.try_lint() end
  end,
})

-- pylint is much slower than the LSP-based linters (ruff/basedpyright), so only
-- run it on save, and only in repos that actually opt into it with a
-- `.pylintrc` (e.g. TM_BC6_ODOO_MADPG2601DPG, HMV-PACKAGE) — this avoids
-- noise/slowdown when editing plain odoo-19.0 core or unrelated python files.
vim.api.nvim_create_autocmd('BufWritePost', {
  group = lint_augroup,
  pattern = '*.py',
  callback = function(event)
    -- Run pylint with cwd set to the directory holding .pylintrc (not
    -- Neovim's own cwd, which doesn't follow the opened file) so it actually
    -- picks up the project's config instead of pylint's bare defaults.
    local pylintrc = vim.fs.find('.pylintrc', { upward = true, path = vim.fs.dirname(event.file) })[1]
    if pylintrc then lint.try_lint('pylint', { cwd = vim.fs.dirname(pylintrc) }) end
  end,
})
