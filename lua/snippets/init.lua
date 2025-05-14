-- ~/.config/nvim/lua/snippets/init.lua

-- Loader for custom LuaSnip snippet files in ~/.config/nvim/lua/snippets
local loader = require 'luasnip.loaders.from_lua'

-- Path to your Lua snippet definitions
local snippet_path = vim.fn.stdpath 'config' .. '/lua/snippets'

-- 1) Initial lazy load of all .lua snippets in that directory
loader.lazy_load { paths = { snippet_path } }

-- 2) Auto-reload snippets on save for rapid development
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = snippet_path .. '/*.lua',
  callback = function()
    loader.load { paths = { snippet_path } }
  end,
})
