return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = {
      lsp_fallback = true, -- Use LSP formatter if available
      timeout_ms = 500,
    },
    -- Optional: specify formatters per filetype
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
    },
  },
}

