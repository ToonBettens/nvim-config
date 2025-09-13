local MiniDeps = require('mini.deps')

--  ( colorscheme agnostic ) ===================================================
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('ColorschemeAgnostic', { clear = true }),
  callback = function()
    -- vim.api.nvim_set_hl(0, 'MatchParen',              { standout = true                 })

    vim.api.nvim_set_hl(0, 'FloatTitle',              { bg = 'NONE'                     })
    vim.api.nvim_set_hl(0, 'FloatBorder',             { bg = 'NONE'                     })

    vim.api.nvim_set_hl(0, 'MiniCursorWordCurrent',   { underline = true                })
    vim.api.nvim_set_hl(0, 'MiniCursorWord',          { underline = true                })

    vim.api.nvim_set_hl(0, 'MiniFilesBorder',         { link = 'FloatBorder'            })
    vim.api.nvim_set_hl(0, 'MiniFilesBorderModified', { link = 'DiagnosticFloatingWarn' })
    vim.api.nvim_set_hl(0, 'MiniFilesCursorLine',     { link = 'CursorLine'             })
    vim.api.nvim_set_hl(0, 'MiniFilesFile',           { link = 'MiniFilesFile'          })
    vim.api.nvim_set_hl(0, 'MiniFilesNormal',         { link = 'NormalFloat'            })
    vim.api.nvim_set_hl(0, 'MiniFilesTitle',          { link = 'FloatTitle'             })
    vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused',   { link = 'FloatTitle'             })

    vim.api.nvim_set_hl(0, 'MiniPickBorder',          { link = 'FloatBorder'            })
    vim.api.nvim_set_hl(0, 'MiniPickBorderBusy',      { link = 'DiagnosticFloatingWarn' })
    vim.api.nvim_set_hl(0, 'MiniPickBorderText',      { link = 'FloatFooter'            })
    -- vim.api.nvim_set_hl(0, 'MiniPickCursor',          { link = 'NormalFloat'            })
    vim.api.nvim_set_hl(0, 'MiniPickIconDirectory',   { link = 'Directory'              })
    vim.api.nvim_set_hl(0, 'MiniPickIconFile',        { link = 'MiniPickNormal'         })
    vim.api.nvim_set_hl(0, 'MiniPickHeader',          { link = 'DiagnosticFloatingHint' })
    vim.api.nvim_set_hl(0, 'MiniPickMatchCurrent',    { link = 'CursorLine'             })
    vim.api.nvim_set_hl(0, 'MiniPickMatchMarked',     { link = 'Visual'                 })
    vim.api.nvim_set_hl(0, 'MiniPickMatchRanges',     { link = 'DiagnosticFloatingHint' })
    vim.api.nvim_set_hl(0, 'MiniPickNormal',          { link = 'NormalFloat'            })
    vim.api.nvim_set_hl(0, 'MiniPickPreviewLine',     { link = 'CursorLine'             })
    vim.api.nvim_set_hl(0, 'MiniPickPreviewRegion',   { link = 'IncSearch'              })
    vim.api.nvim_set_hl(0, 'MiniPickPrompt',          { link = 'FloatTitle'             })
    vim.api.nvim_set_hl(0, 'MiniPickPromptCaret',     { link = 'MiniPickPrompt'         })
    vim.api.nvim_set_hl(0, 'MiniPickPromptPrefix',    { link = 'MiniPickBorder'         })
  end,
})

--  ( colorschemes ) ===========================================================
MiniDeps.now(function()
  MiniDeps.add('catppuccin/nvim')
  MiniDeps.add('folke/tokyonight.nvim')
  MiniDeps.add('AlexvZyl/nordic.nvim')
  MiniDeps.add('neanias/everforest-nvim')

  MiniDeps.add('rebelot/kanagawa.nvim')
  require('kanagawa').setup({
    overrides = function(colors)
      local theme = colors.theme
      return {
        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
      }
    end,
  })
end)

--  ( pick colorscheme ) =======================================================
vim.cmd.colorscheme('kanagawa-wave')
