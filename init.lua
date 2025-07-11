-- Set leader key
vim.g.mapleader = " "

-- Editor settings
vim.opt.number = true
vim.opt.relativenumber = true

-- hightligh after yank
vim.api.nvim_set_hl(0, "YankHighlight", { fg = "#ffffff", bg = "#FFA500", bold = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 500 })
	end,
})

-- Load plugin system
require("plugins")
