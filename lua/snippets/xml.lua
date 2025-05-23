local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- Form view
  s('vform', {
    t {
      '<record id="',
    },
    i(1, 'model_form_view'),
    t {
      '" model="ir.ui.view">',
      '  <field name="name">',
    },
    i(2, 'form view name'),
    t {
      '</field>',
      '  <field name="model">',
    },
    i(3, 'model.name'),
    t {
      '</field>',
      '  <field name="arch" type="xml">',
      '    <form string="',
    },
    i(4, 'Form Title'),
    t {
      '">',
      '      <sheet>',
      '        <group>',
      '          <field name="',
    },
    i(5, 'field_name'),
    t {
      '"/>',
      '        </group>',
      '      </sheet>',
      '    </form>',
      '  </field>',
      '</record>',
    },
  }),

  -- Tree (list) view
  s('vlist', {
    t {
      '<record id="',
    },
    i(1, 'model_tree_view'),
    t {
      '" model="ir.ui.view">',
      '  <field name="name">',
    },
    i(2, 'tree view name'),
    t {
      '</field>',
      '  <field name="model">',
    },
    i(3, 'model.name'),
    t {
      '</field>',
      '  <field name="arch" type="xml">',
      '    <tree string="',
    },
    i(4, 'List Title'),
    t {
      '">',
      '      <field name="',
    },
    i(5, 'field_name'),
    t {
      '"/>',
      '    </tree>',
      '  </field>',
      '</record>',
    },
  }),

  -- Search view
  s('vsearch', {
    t {
      '<record id="',
    },
    i(1, 'model_search_view'),
    t {
      '" model="ir.ui.view">',
      '  <field name="name">',
    },
    i(2, 'search view name'),
    t {
      '</field>',
      '  <field name="model">',
    },
    i(3, 'model.name'),
    t {
      '</field>',
      '  <field name="arch" type="xml">',
      '    <search>',
      '      <field name="',
    },
    i(4, 'field_name'),
    t {
      '"/>',
      '    </search>',
      '  </field>',
      '</record>',
    },
  }),
}
