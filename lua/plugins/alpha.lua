return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Define headers (ASCII banners)
		local headers = {
			{
				[[                               __                ]],
				[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
				[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
				[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
				[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
				[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
			},
		}

		-- Randomly pick a header
		math.randomseed(os.time())
		dashboard.section.header.val = headers[math.random(#headers)]

		-- Buttons
		dashboard.section.buttons.val = {
			dashboard.button("f", "🔍  Find file", ":Telescope find_files<CR>"),
			dashboard.button("n", "📄  New file", ":ene <BAR> startinsert<CR>"),
			dashboard.button("r", "🕘  Recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("g", "🔎  Grep text", ":Telescope live_grep<CR>"),
			dashboard.button("c", "🔧  Config", ":e $MYVIMRC<CR>"),
			dashboard.button("q", "🚪  Quit NVIM", ":qa<CR>"),
		}

		-- Footer
		dashboard.section.footer.val = "🚀 Happy Hacking with Neovim!"
		dashboard.section.footer.opts.hl = "Type"

		-- Final setup
		alpha.setup(dashboard.opts)

		-- Autostart dashboard on nvim with no args or `nvim .`
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				local argv = vim.fn.argv()
				if vim.fn.argc() == 0 or (argv[1] and vim.fn.isdirectory(argv[1]) == 1) then
					require("alpha").start()
				end
			end,
		})
	end,
}
