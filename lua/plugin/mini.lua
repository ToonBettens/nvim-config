local MiniDeps = require('mini.deps')

-- NOTE: The plugins from mini.nvim were all bootstrapped together in one big package (see init.lua).
--       This means we do not need to use MiniDeps.add for these plugins.

-- ( mini.ai ) ================================================================
MiniDeps.later(function()
  local ai = require('mini.ai')
  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      -- textobject definitions (scm-files) taken from nvim-treesitter-textobjects
      o = ai.gen_spec.treesitter({ -- code block
        a = { '@block.outer', '@conditional.outer', '@loop.outer' },
        i = { '@block.inner', '@conditional.inner', '@loop.inner' },
      }),
      f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
      c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
      t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
      d = MiniExtra.gen_ai_spec.number(), -- digit
      g = MiniExtra.gen_ai_spec.buffer(), -- buffer
      u = ai.gen_spec.function_call(), -- u for 'Usage'
      U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
    },
  })
end)

--  ( mini.align ) =============================================================
MiniDeps.later(function() require('mini.align').setup() end)

--  ( mini.basics ) ============================================================
MiniDeps.now(function()
  require('mini.basics').setup({
    options = { basic = false },
    mappings = { option_toggle_prefix = '', windows = true, move_with_alt = true }
  })
end)

--  ( mini.bracketed ) =========================================================
MiniDeps.later(function() require('mini.bracketed').setup() end)

--  ( mini.bufremove ) =========================================================
MiniDeps.later(function() require('mini.bufremove').setup() end)

--  ( mini.clue ) ==============================================================
MiniDeps.later(function() require('mini.clue').setup() end)

--  ( mini.comment ) ===========================================================
MiniDeps.later(function() require('mini.comment').setup() end)

--  ( mini.cursorword ) ========================================================
MiniDeps.later(function()
  require('mini.cursorword').setup()
  vim.api.nvim_set_hl(0, 'MiniCursorWordCurrent', { underline = true })
  vim.api.nvim_set_hl(0, 'MiniCursorWord', { underline = true })
end)

--  ( mini.diff ) ==============================================================
MiniDeps.later(function() require('mini.diff').setup() end)

--  ( mini.extra ) ==============================================================
MiniDeps.now(function() require('mini.extra').setup() end)

--  ( mini.files ) =============================================================
MiniDeps.now(function()
  require('mini.files').setup()

  -- toggle dotfiles
  local show_dotfiles = true
  local filter_show = function(fs_entry) return true end
  local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, '.') end
  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
  end

  -- set focused directory as current working directory
  local set_cwd = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then return vim.notify('Cursor is not on valid entry') end
    vim.fn.chdir(vim.fs.dirname(path))
  end

  -- Yank in register full path of entry under cursor
  local yank_path = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then return vim.notify('Cursor is not on valid entry') end
    vim.fn.setreg(vim.v.register, path)
  end

  -- Split window in target window
  local split_window = function(direction)
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. ' split')
      return vim.api.nvim_get_current_win()
    end)
    MiniFiles.set_target_window(new_target)
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = args.data.buf_id, desc = 'Toggle hidden files' })
      vim.keymap.set('n', 'g~', set_cwd, { buffer = args.data.buf_id, desc = 'Set cwd' })
      vim.keymap.set('n', 'gy', yank_path, { buffer = args.data.buf_id, desc = 'Set cwd' })
      vim.keymap.set('n', '<C-w>s', function() split_window('horizontal') end, { buffer = args.data.buf_id, desc = 'Split horizontal' })
      vim.keymap.set('n', '<C-w>v', function() split_window('vertical') end, { buffer = args.data.buf_id, desc = 'Split vertical' })
    end,
  })

  -- default bookmarks
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerOpen',
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'BT' })
      MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
      MiniFiles.set_bookmark('~', '~', { desc = 'Home directory' })
    end,
  })

  -- properly handle rename events with LSP's
  vim.api.nvim_create_autocmd("User",{
    pattern = "MiniFilesActionRename",
    callback = function(event)
      Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end
  })

end)

--  ( mini.git ) ================================================================
-- TODO: MiniDeps.now(function() require('mini.git').setup() end)

--  ( mini.hipatterns ) =========================================================
MiniDeps.later(function()
  local hipatterns = require('mini.hipatterns')
  hipatterns.setup({
    highlighters = {
      fixme = MiniExtra.gen_highlighter.words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = MiniExtra.gen_highlighter.words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = MiniExtra.gen_highlighter.words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = MiniExtra.gen_highlighter.words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

--  ( mini.icons ) =============================================================
MiniDeps.now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })
  MiniDeps.later(MiniIcons.mock_nvim_web_devicons)
  MiniDeps.later(MiniIcons.tweak_lsp_kind)
end)

--  ( mini.indentscope ) =======================================================
MiniDeps.later(function() require('mini.indentscope').setup() end)

--  ( mini.jump ) ==============================================================
MiniDeps.later(function() require('mini.jump').setup() end)

--  ( mini.keymap ) ============================================================
-- TODO

--  ( mini.misc ) ==============================================================
MiniDeps.later(function()
  require('mini.misc').setup({ make_global = { 'put', 'put_text', 'bench_time' } })
  MiniMisc.setup_auto_root()
  MiniMisc.setup_termbg_sync()
end)

--  ( mini.move ) ==============================================================
MiniDeps.later(function() require('mini.move').setup({ options = { reindent_linewise = false } }) end)

--  ( mini.notify ) ============================================================
-- TODO

--  ( mini.operators ) =========================================================
MiniDeps.later(function() require('mini.operators').setup() end)

--  ( mini.pairs ) =============================================================
MiniDeps.later(function()
  require('mini.pairs').setup({
    modes = { insert = true, command = true, terminal = false },
  })

  -- Hook into pairs.open for custom matching logic
  local open = MiniPairs.open
  ---@diagnostic disable-next-line: duplicate-set-field
  MiniPairs.open = function(pair, neigh_pattern)
    if vim.fn.getcmdline() ~= "" then
      return open(pair, neigh_pattern)
    end
    local o, c = pair:sub(1, 1), pair:sub(2, 2)
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local next = line:sub(cursor[2] + 1, cursor[2] + 1)
    local before = line:sub(1, cursor[2])

    -- better deal with markdown code blocks
    if o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
      return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
    end

    -- skip autopair when next character matches skip_next
    local skip_next = [=[[%w%%%'%[%"%.%`%$]]=]
    if next ~= "" and next:match(skip_next) then
      return o
    end

    -- skip autopair when cursor is inside treesitter string node
    local skip_ts = { 'string' }
    if #skip_ts > 0 then
      local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
      for _, capture in ipairs(ok and captures or {}) do
        if vim.tbl_contains(skip_ts, capture.capture) then
          return o
        end
      end
    end

    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    if next == c and c ~= o then
      local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
      local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
      if count_close > count_open then
        return o
      end
    end
    return open(pair, neigh_pattern)
  end
end)


--  ( mini.pick ) ==============================================================
MiniDeps.now(function()
  require('mini.pick').setup({
    mappings = {
      caret_left = '<M-l>',
      caret_right = '<M-h>',
      choose_in_split = '<C-w>s',
      choose_in_vsplit = '<C-w>v',
      delete_left = '',
      delete_word = '',
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
    window = {
      config = function()
        local height = math.floor(0.8 * vim.o.lines)
        local width = math.floor(0.8 * vim.o.columns)
        return {
          anchor = 'NW', height = height, width = width,
          row = math.floor(0.3 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
        }
      end,
    },
  })

  vim.ui.select = MiniPick.ui_select

  local projects_path = vim.fn.expand('~/projects')
  ---@diagnostic disable-next-line: duplicate-set-field
  MiniPick.registry.projects = function()
    MiniPick.builtin.cli({
      command = { 'fd', '--type', 'd', '--hidden', '--follow', '\\.git$', projects_path },
      postprocess = function(lines)
        local seen, unique = {}, {}
        for _, line in ipairs(lines) do
          if line ~= '' then
            local project = vim.fs.relpath(projects_path, vim.fs.dirname(line:sub(1, -2)))
            if not seen[project] and project ~= nil then
              table.insert(unique, project)
              seen[project] = true
            end
          end
        end
        return unique
      end,
    }, {
      source = {
        name = 'Projects',
        choose = function(project)
          vim.schedule(function() MiniFiles.open(vim.fs.joinpath(projects_path, project)) end)
        end,
      },
      mappings = {
        mark = '',
        mark_all = ''
      }
    })
  end
end)

--  ( mini.sessions ) ==========================================================
MiniDeps.now(function() require('mini.sessions').setup() end)

--  ( mini.snippets ) ==========================================================
-- TODO

--  ( mini.splitjoin ) =========================================================
MiniDeps.now(function() require('mini.splitjoin').setup() end)

--  ( mini.starter ) ===========================================================
MiniDeps.now(function()
  local starter = require('mini.starter')
  starter.setup({
    items = {
      starter.sections.recent_files(),
      starter.sections.builtin_actions(),
    },
    header = function()
      local banner = [[

      ████ ██████           █████      ██
     ███████████             █████ 
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████

      ]]
      local hour = tonumber(vim.fn.strftime('%H'))
      local part_id = math.floor((hour + 4) / 8) + 1
      local day_part = ({ 'evening', 'morning', 'afternoon', 'evening' })[part_id]
      local username = vim.uv.os_get_passwd()['username'] or 'USERNAME'
      local greeting = ('Good %s, %s'):format(day_part, username)

      local n = math.floor((70 - greeting:len()) / 2)
      return banner .. string.rep(' ', n) .. greeting
    end,
  })
end)

--  ( mini.statusline ) ========================================================
MiniDeps.now(function() require('mini.statusline').setup() end)

--  ( mini.surround ) ==========================================================
MiniDeps.now(function() require('mini.surround').setup() end)

--  ( mini.trailspace ) ========================================================
MiniDeps.later(function() require('mini.trailspace').setup() end)
