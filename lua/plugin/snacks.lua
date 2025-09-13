local MiniDeps = require('mini.deps')

MiniDeps.now(function()
  MiniDeps.add('folke/snacks.nvim')
  require('snacks').setup({
    bigfile = { enabled = true },
    scroll = { enabled = true },
  })
end)
