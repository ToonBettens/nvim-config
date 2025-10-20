local MiniDeps = require('mini.deps')

MiniDeps.later(function()
  local MiniFiles = require('mini.files')
  local MiniPick = require('mini.pick')
  local MiniSessions = require('mini.sessions')
  local MiniTrailspace = require('mini.trailspace')
  local MiniMisc = require('mini.misc')
  local MiniClue = require('mini.clue')
  local CC = require('codecompanion')

  --  ( Default Neovim ) =========================================================

  -- Saving with `<leader>w`
  vim.keymap.set(
    'n',
    '<leader>w',
    function()
      if vim.api.nvim_get_option_value('buftype', { buf = 0 }) == '' then
        vim.cmd.write()
      end
    end,
  { desc = 'Save File', silent = true }
  )

  -- Save in insert mode with `<C-s>`
  vim.keymap.set('i', '<C-s>', function() vim.cmd.write() vim.cmd.startinsert() end, { desc = 'Save File', silent = true })

  -- Disable `s` shortcut (use `cl` instead)
  vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

  -- Clear command line with `<Esc>`
  vim.keymap.set('n', '<esc>', vim.cmd.stopinsert)

  -- Keep line selected while indenting
  vim.keymap.set('x', '<', '<gv')
  vim.keymap.set('x', '>', '>gv')

  -- System clipboard
  vim.keymap.set('x', '<M-y>', [["+y]])
  vim.keymap.set('n', '<M-y><M-y>', [["+yy]])
  vim.keymap.set('n', '<M-Y>', [["+yy]])
  vim.keymap.set('n', '<M-p>', [["+p]])


  --  ( Toggle ) =================================================================
  local toggle_opt = function(opt, keymap, on, off)
    on = on or true
    off = off or false
    Snacks.toggle({
      name = opt .. ' (opt)',
      get = function() return vim.opt[opt]:get() == on end,
      set = function(state)
        if state then
          vim.opt[opt] = on
        else
          vim.opt[opt] = off
        end
      end,
    }):map(keymap)
  end

  toggle_opt('number', '<leader>yon')
  toggle_opt('relativenumber', '<leader>yor')
  toggle_opt('hlsearch', '<leader>yoh')
  toggle_opt('wrap', '<leader>yow')
  toggle_opt('textwidth', '<leader>yot', 80, 0)
  toggle_opt('spell', '<leader>yos')

  Snacks.toggle({
    name = 'Mini Pairs',
    get = function() return not vim.g.minipairs_disable end,
    set = function(state) vim.g.minipairs_disable = not state end,
  }):map('<leader>yp')

  Snacks.toggle({
    name = 'Diagnostics',
    get = vim.diagnostic.is_enabled,
    set = vim.diagnostic.enable,
  }):map('<leader>yd')

  Snacks.toggle({
    name = 'Completion',
    get = function() return not vim.g.cmp_disable end,
    set = function(state) vim.g.cmp_disable = not state end,
  }):map('<leader>yc')

  Snacks.toggle({
    name = 'Markdown Rendering',
    get = function() return require('render-markdown').get() end,
    set = function(state) require('render-markdown').set(state) end,
  }):map('<leader>ym')


  --  ( Explore ) ================================================================
  vim.keymap.set(
    'n',
    '<leader>ef',
    function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname ~= '' and vim.uv.fs_stat(bufname) then
        MiniFiles.open(bufname)
      else
        MiniFiles.open()
      end
    end,
    { desc = 'Explore Files' }
  )
  vim.keymap.set('n', '<leader>ew', function() MiniFiles.open() end,                                 { desc = 'Explore Working Directory' })
  vim.keymap.set('n', '<leader>ec', function() MiniFiles.open(vim.fn.stdpath('config')) end,         { desc = 'Explore Configuration' })
  vim.keymap.set('n', '<leader>eh', function() MiniFiles.open(vim.env.HOME) end,                     { desc = 'Explore Home' })
  vim.keymap.set('n', '<leader>ep', function() MiniPick.registry.projects() end,                     { desc = 'Explore Projects' })


  --  ( Sessions ) ===============================================================
  vim.keymap.set('n', '<leader>ss', function() require('util.sessions').start_session() end,         { desc = 'Start Session' })
  vim.keymap.set('n', '<leader>sp', function() MiniSessions.select() end,                            { desc = 'Pick Session' })
  vim.keymap.set('n', '<leader>sd', function() require('util.sessions').delete_session_picker() end, { desc = 'Pick Session' })


  --  ( Pick ) ===================================================================
  vim.keymap.set('n', '<leader>p/', function() MiniPick.registry.history({scope='/'}) end,           { desc = '"/" history' })
  vim.keymap.set('n', '<leader>p:', function() MiniPick.registry.history({scope=":"}) end,           { desc = '":" history' })
  vim.keymap.set('n', '<leader>pb', function() MiniPick.registry.buffers() end,                      { desc = 'Buffers' })
  vim.keymap.set('n', '<leader>pd', function() MiniPick.registry.diagnostic({scope="current"}) end,  { desc = 'Diagnostic buffer' })
  vim.keymap.set('n', '<leader>pf', function() MiniPick.registry.files() end,                        { desc = 'Files' })
  vim.keymap.set('n', '<leader>pg', function() MiniPick.registry.grep_live() end,                    { desc = 'Grep live' })
  vim.keymap.set('n', '<leader>pG', function() MiniPick.registry.grep({pattern="<cword>"}) end,      { desc = 'Grep current word' })
  vim.keymap.set('n', '<leader>ph', function() MiniPick.registry.help() end,                         { desc = 'Help tags' })
  vim.keymap.set('n', '<leader>pH', function() MiniPick.registry.hl_groups() end,                    { desc = 'Highlight groups' })
  vim.keymap.set('n', '<leader>pr', function() MiniPick.registry.resume() end,                       { desc = 'Resume' })
  vim.keymap.set('n', '<leader>ps', function() MiniSessions.select() end,                            { desc = 'Session' })


  --  ( LSP/Diagnostics ) ========================================================
  -- TODO: formatting (conform)
  -- TODO: diagnostics (trouble)
  vim.keymap.set('n', '<leader>la', function() vim.lsp.buf.code_action() end,                        { desc = 'Action' })
  vim.keymap.set('n', '<leader>ld', function() vim.diagnostic.open_float() end,                      { desc = 'Diagnostics popup' })
  vim.keymap.set('n', '<leader>li', function() vim.lsp.buf.hover() end,                              { desc = 'Information' })
  vim.keymap.set('n', '<leader>lj', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Next diagnostic' })
  vim.keymap.set('n', '<leader>lk', function() vim.diagnostic.jump({ count = -1, float = true}) end, { desc = 'Prev diagnostic' })
  vim.keymap.set('n', '<leader>lr', function() vim.lsp.buf.rename() end,                             { desc = 'Rename Symbol' })
  vim.keymap.set('n', '<leader>ls', function() vim.lsp.buf.definition() end,                         { desc = 'Source definition' })


  --  ( AI ) =====================================================================
  vim.cmd('cab CC CodeCompanion')
  vim.keymap.set({ 'n', 'v' }, '<leader>aa', function() CC.actions({}) end, { desc = 'Action Palette' } )
  vim.keymap.set({ 'n', 'v' }, '<leader>ac', function() CC.toggle() end, { desc = 'Toggle Chat' })
  vim.keymap.set('v', '<leader>as', function() CC.chat({fargs = { 'Add' }}) end, { desc = 'Send Selection to Chat' })


  --  ( Other ) ==================================================================
  vim.keymap.set('n', '<leader>ot', function() MiniTrailspace.trim() MiniTrailspace.trim_last_lines() end, { desc = 'Trim file' })
  vim.keymap.set('n', '<leader>oz', function() MiniMisc.zoom() end, { desc = 'Zoom' })


  --  ( Register Clues ) =========================================================
  MiniClue.setup({
    window = { config = { width = 40 }},
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },

      -- `s` key
      { mode = 'n', keys = 's' },
      { mode = 'x', keys = 's' },

      -- bracketed motions
      { mode = 'n', keys = ']' },
      { mode = 'n', keys = '[' },
    },
    clues = {
      -- TODO: leader_group_clues,
      MiniClue.gen_clues.builtin_completion(),
      MiniClue.gen_clues.g(),
      MiniClue.gen_clues.marks(),
      MiniClue.gen_clues.registers(),
      MiniClue.gen_clues.windows({ submode_resize = true }),
      MiniClue.gen_clues.z(),
      {
        { mode = 'n', keys = '<leader>y', desc = '+Toggle' },
        { mode = 'n', keys = '<leader>yo', desc = '+Options' },
        { mode = 'n', keys = '<leader>e', desc = '+Explore' },
        { mode = 'n', keys = '<leader>p', desc = '+Pick' },
        { mode = 'n', keys = '<leader>l', desc = '+LSP' },
        { mode = 'n', keys = '<leader>a', desc = '+AI' },
        { mode = 'n', keys = '<leader>o', desc = '+Other' },
      },
    },
  })
end)
