return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				direction = "horizontal", -- or "vertical" / "float"
				size = 15,
				open_mapping = [[<leader>t]],
				shade_terminals = true,
				start_in_insert = true,
				persist_mode = false,
			})
		end,
	},
}
