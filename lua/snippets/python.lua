local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Char field
  s('fchar', {
    t 'fields.Char(string="',
    i(1, 'Field Label'),
    t '")',
  }),

  -- Text field
  s('ftext', {
    t 'fields.Text(string="',
    i(1, 'Field Label'),
    t '")',
  }),

  -- Integer field
  s('fint', {
    t 'fields.Integer(string="',
    i(1, 'Field Label'),
    t '")',
  }),

  -- Float field
  s('ffloat', {
    t 'fields.Float(string="',
    i(1, 'Field Label'),
    t '")',
  }),

  -- Boolean field
  s('fbool', {
    t 'fields.Boolean(string="',
    i(1, 'Field Label'),
    t '")',
  }),

  -- Date field
  s('fdate', {
    t 'fields.Date(string="',
    i(1, 'Field Label'),
    t '")',
  }),

  -- Datetime field
  s('fdt', {
    t 'fields.Datetime(string="',
    i(1, 'Field Label'),
    t '")',
  }),

  -- Many2one field
  s('fm2o', {
    t 'fields.Many2one("',
    i(1, 'res.partner'),
    t '", string="',
    i(2, 'Field Label'),
    t '")',
  }),

  -- One2many field
  s('fo2m', {
    t 'fields.One2many("',
    i(1, 'model.name'),
    t '", "',
    i(2, 'field_id'),
    t '", string="',
    i(3, 'Field Label'),
    t '")',
  }),

  -- Many2many field
  s('fm2m', {
    t 'fields.Many2many("',
    i(1, 'res.partner'),
    t '", string="',
    i(2, 'Field Label'),
    t '")',
  }),
}
