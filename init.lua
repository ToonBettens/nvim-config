-- Bootstrap 'mini.nvim'
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
  vim.cmd.echo('"Installing `mini.nvim`" | redraw"')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use "stable" branch
    -- '--branch', 'stable',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd.packadd('"mini.nvim | helptags ALL"')
  vim.cmd.echo('"Installed `mini.nvim`" | redraw"')
end

-- Set up 'mini.deps' immediately to have its `now()` and `later()` helpers
require('mini.deps').setup({
  path = { package = vim.fn.stdpath('config') .. '/deps' }
})

-- Source configuration files
require('options')
require('plugin.snacks')
require('plugin.colorscheme')
require('plugin.treesitter')
require('plugin.mini')
require('plugin.notify')
require('plugin.lsp')
require('plugin.markdown')
require('plugin.cmp')
require('mappings')
