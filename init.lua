-- Bootstrap 'mini.nvim'
local package_path = vim.fn.stdpath('config') .. '/pkg'
local mini_path = package_path .. '/pack/deps/start/mini.nvim'

if not vim.uv.fs_stat(mini_path) then
  vim.cmd.echo('"Installing mini.nvim"')
  local clone_cmd = {'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path}
  vim.fn.system(clone_cmd)
  vim.cmd.packadd('mini.nvim')
  vim.cmd.helptags('ALL')
  vim.cmd.echo('"Installed `mini.nvim`"')
  vim.cmd.redraw()
end

-- Ensure mini.nvim is loaded from your packaging directory
vim.opt.rtp:prepend(mini_path)

-- Set up 'mini.deps' first
require('mini.deps').setup({
  path = { package = package_path }  -- location for packaging
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
require('mappings')

-- MiniDeps lazy-loading finished hook
require('mini.deps').later(function()
  vim.cmd.doautocmd('User MiniDepsAllLaterLoaded')
end)
