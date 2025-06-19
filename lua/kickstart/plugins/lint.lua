return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- This tells nvim-lint to run pycodestyle with a max line length of 88 characters.
      -- This is the recommended fix to align with the 'black' formatter.
      lint.linters.pycodestyle = {
        cmd = 'pycodestyle',
        args = { '--max-line-length=88' },
      }

      lint.linters_by_ft = {
        python = { 'pycodestyle' }, -- Explicitly enable pycodestyle for Python files
        markdown = { 'markdownlint' },
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
