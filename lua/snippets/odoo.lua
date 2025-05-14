-- ~/.config/nvim/lua/snippets/odoo.lua
-- Odoo-specific snippets for Python using LuaSnip

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('python', {
  -- Basic Odoo model boilerplate
  s(
    'odmodel',
    fmt(
      [[
from odoo import models, fields

class {}(models.Model):
    _name = '{}'
    _description = '{}'

    name = fields.Char(string='{}')
    {}
]],
      {
        i(1, 'MyModel'),
        i(2, 'module.my_model'),
        i(3, 'My Model'),
        i(4, 'Name'),
        i(0),
      }
    )
  ),

  -- Char field
  s(
    'odchar',
    fmt("x_{} = fields.Char(string='{}')", {
      i(1, 'field_name'),
      i(2, 'Label'),
    })
  ),

  -- Float field
  s(
    'odfloat',
    fmt("x_{} = fields.Float(string='{}')", {
      i(1, 'field_name'),
      i(2, 'Label'),
    })
  ),

  -- Many2one field
  s(
    'odm2o',
    fmt("x_{} = fields.Many2one('{}', string='{}')", {
      i(1, 'partner_id'),
      i(2, 'res.partner'),
      i(3, 'Partner'),
    })
  ),

  -- One2many field
  s(
    'odone2many',
    fmt("x_{} = fields.One2many('{}', '{}', string='{}')", {
      i(1, 'line_ids'),
      i(2, 'module.line'),
      i(3, 'parent_id'),
      i(4, 'Lines'),
    })
  ),

  -- Computed field stub
  s(
    'odcompute',
    fmt(
      [[
@api.depends('{}')
def _compute_{}(self):
    for rec in self:
        {}
]],
      {
        i(1, 'field_name'),
        i(2, 'field_name'),
        i(0),
      }
    )
  ),

  -- Override create()
  s(
    'odcreate',
    fmt(
      [[
@api.model
def create(self, vals):
    {}
    return super().create(vals)
]],
      {
        i(1, 'pass'),
      }
    )
  ),

  -- Override write()
  s(
    'odwrite',
    fmt(
      [[
def write(self, vals):
    {}
    return super().write(vals)
]],
      {
        i(1, 'pass'),
      }
    )
  ),
})
