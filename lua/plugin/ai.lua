local MiniDeps = require('mini.deps')

MiniDeps.later(function()

  MiniDeps.add('github/copilot.vim')
  vim.g.copilot_enabled = false

  MiniDeps.add({
    source = 'olimorris/codecompanion.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
    hooks = { }
  })
  require('util.codecompanion'):init()
  require('codecompanion').setup({
    strategies = {
      chat = { adapter = 'copilot' },
      inline = { adapter = 'copilot' },
      cmd = { adapter = 'copilot' },
    },
    display = {
      action_palette = { provider = 'default' },
      -- chat = { show_settings = true }
    },
  })
end)
