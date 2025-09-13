local MiniDeps = require('mini.deps')

MiniDeps.later(function()
  MiniDeps.add('j-hui/fidget.nvim')
  require('fidget').setup({})
end)
