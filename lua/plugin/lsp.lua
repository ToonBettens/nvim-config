local MiniDeps = require('mini.deps')

MiniDeps.later(function()
  MiniDeps.add('neovim/nvim-lspconfig')

  MiniDeps.add('williamboman/mason.nvim')
  require('mason').setup({
    ui = { border = "single" }
  })

  MiniDeps.add('williamboman/mason-lspconfig.nvim')
  require('mason-lspconfig').setup({ automatic_enable = false })

  MiniDeps.add('folke/lazydev.nvim')  -- Julia language server support for neovim configs
  require('lazydev').setup({
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'snacks.nvim', words = { 'Snacks' } },
    },
  })

  -- Enabled language servers
  vim.lsp.enable('lua_ls')
  vim.lsp.enable('ruff')
  vim.lsp.enable('pyrefly')
  -- vim.lsp.enable('basedpyright')
  vim.lsp.enable('julials')

end)
