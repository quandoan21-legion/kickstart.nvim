local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('lua', {
  s('quandoan', {
    t "print('[",
    i(1, 'label'),
    t "] =>', vim.inspect(",
    i(2, 'value'),
    t '))',
  }),
})
