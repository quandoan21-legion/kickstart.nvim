-- Database client (vim-dadbod + dadbod-ui) wired to the local Postgres
-- instance used by the Odoo dev setup, so you can browse/query any of your
-- Odoo databases without leaving Neovim.

vim.pack.add {
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
}

-- Odoo's own conf already holds the Postgres credentials; read them from there
-- instead of duplicating them in this config.
local function read_odoo_db_conf(conf_path)
  local creds = { host = '127.0.0.1', port = '5432', user = 'odoo', password = '' }
  local f = io.open(conf_path, 'r')
  if not f then return creds end
  for line in f:lines() do
    local key, value = line:match '^%s*(db_%a+)%s*=%s*(.-)%s*$'
    if key == 'db_host' then creds.host = value end
    if key == 'db_port' then creds.port = value end
    if key == 'db_user' then creds.user = value end
    if key == 'db_password' then creds.password = value end
  end
  f:close()
  return creds
end

local creds = read_odoo_db_conf(vim.fn.expand '~/Desktop/odoo-19.0/odoo.conf')

-- Build one DBUI entry per existing Odoo database so you can browse/query any
-- of them without hand-editing connection strings.
local function list_odoo_databases()
  local ok, result = pcall(
    vim.system,
    {
      'psql',
      '-h',
      creds.host,
      '-p',
      creds.port,
      '-U',
      creds.user,
      '-d',
      'postgres',
      '-At',
      '-c',
      "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres' ORDER BY datname;",
    },
    { env = { PGPASSWORD = creds.password }, text = true, timeout = 3000 }
  )
  if not ok then return {} end
  local completed = result:wait()
  if completed.code ~= 0 or not completed.stdout then return {} end
  return vim.split(vim.trim(completed.stdout), '\n', { trimempty = true })
end

-- NOTE: `vim.g.dbs[k] = v` would silently not persist (vim.g.<table> returns a
-- copy, not a live reference), so build the table locally and assign it once.
local dbs = {}
for _, dbname in ipairs(list_odoo_databases()) do
  dbs[dbname] = string.format('postgres://%s:%s@%s:%s/%s', creds.user, creds.password, creds.host, creds.port, dbname)
end
vim.g.dbs = dbs

vim.g.db_ui_use_nerd_fonts = vim.g.have_nerd_font
vim.g.db_ui_save_location = vim.fn.stdpath 'data' .. '/db_ui_queries'

vim.keymap.set('n', '<leader>Du', '<cmd>DBUIToggle<CR>', { desc = 'Database: Toggle [U]I' })
vim.keymap.set('n', '<leader>Df', '<cmd>DBUIFindBuffer<CR>', { desc = 'Database: [F]ind buffer' })
