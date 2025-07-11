return {
  -- Load LazyVim and import its plugins
  {
    "LazyVim/LazyVim",
    lazy = false,
    priority = 10000,
    config = function()
      -- Optional config (themes, globals, etc.)
    end,
  },

  -- Example of adding more plugins to LazyVim
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-telescope/telescope.nvim" },
}

