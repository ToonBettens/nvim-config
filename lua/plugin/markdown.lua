local MiniDeps = require('mini.deps')

MiniDeps.later(function()
  MiniDeps.add({
    source = 'MeanderingProgrammer/render-markdown.nvim',
    depends = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim'},
  })
  require('render-markdown').setup({
    enabled = true,
    file_types = { 'markdown', 'codecompanion', 'quarto' },
  })
end)
