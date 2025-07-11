return {
  "mbbill/undotree",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree" },
  },
  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}

