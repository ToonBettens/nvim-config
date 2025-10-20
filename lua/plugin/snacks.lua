local MiniDeps = require('mini.deps')

MiniDeps.now(function()
  MiniDeps.add('folke/snacks.nvim')
  require('snacks').setup({
    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024,
    },
    scroll = { enabled = true },
  })
end)
