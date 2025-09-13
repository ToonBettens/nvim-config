local MiniDeps = require('mini.deps')

MiniDeps.later(function()
  MiniDeps.add('neovim/nvim-lspconfig')

  MiniDeps.add('williamboman/mason.nvim')
  require('mason').setup({
    ui = { border = "single" }
  })

  MiniDeps.add('williamboman/mason-lspconfig.nvim')
  require('mason-lspconfig').setup({
    automatic_enable = { exclude = { 'julials' }}
  })

  MiniDeps.add('folke/lazydev.nvim')
  require('lazydev').setup({
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'snacks.nvim', words = { 'Snacks' } },
    },
  })

  -- ( Julia ) =================================================================
  vim.lsp.enable('julials')

  -- vim.lsp.config('jetls', {
  --   cmd = {
  --     'julia', '+1.12',
  --     '--startup-file=no',
  --     '--history-file=no',
  --     '--project=/path/to/JETLS.jl',
  --     '/path/to/JETLS.jl/runserver.jl',
  --   },
  --   filetypes = {'julia'},
  -- })
  -- vim.lsp.enable('jetls')

end)
