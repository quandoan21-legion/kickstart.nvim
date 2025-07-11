local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "plugins.lazyvim" },
	{ import = "plugins.nvim_tree" },
	{ import = "plugins.telescope" },
	{ import = "plugins.lsp" },
	{ import = "plugins.cmp" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.playground" },
	{ import = "plugins.conform" },
	{ import = "plugins.autosave" },
	{ import = "plugins.undotree" },
	{ import = "plugins.bufferline" },
	{ import = "plugins.alpha" },
	{ import = "plugins.colorscheme" },
	{ import = "plugins.autopairs" },
	{ import = "plugins.lazy_git" },
	{ import = "plugins.lazy_git" },
	{ import = "plugins.vim_surround" },
	{ import = "plugins.indentscope" },
	{ import = "plugins.toggle_term" },
	-- you can keep adding more plugin files here
})
