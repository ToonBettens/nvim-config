local MiniDeps = require('mini.deps')
local c = require('util.collections')

--  ( Configuration ) ==========================================================
local installed_langs = {
  'c', 'vim', 'vimdoc', 'lua', 'query', 'bash', 'tcl',
  'gitignore', 'markdown', 'markdown_inline', 'html',
  'css', 'javascript', 'csv', 'json', 'yaml', 'toml',
  'julia', 'python', 'rust', 'cpp', 'regex', 'verilog',
  'vhdl', 'powershell'
}
local highlight_exclude = { }
local indent_exclude = { 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' }


--  ( Nvim-Treesitter Setup ) ==================================================
MiniDeps.now(function()
  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    checkout = 'main',
  })


  local highlight_set = c.as_set(c.filter(installed_langs, function(lang)
    return not c.in_set(lang, c.as_set(highlight_exclude))
  end))

  local indent_set = c.as_set(c.filter(installed_langs, function(lang)
    return not c.in_set(lang, c.as_set(indent_exclude))
  end))

  -- Install missing parsers
  local to_install = c.filter(installed_langs, function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end)
  if #to_install > 0 then
    require('nvim-treesitter').install(to_install)
  end

  -- Setup per-buffer Treesitter features
  vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.iter(installed_langs):map(vim.treesitter.language.get_filetypes):flatten():totable(),
    callback = function(ev)
      local buf = ev.buf
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft

      if c.in_set(lang, highlight_set) then
        vim.treesitter.start(buf)
      end
      if c.in_set(lang, indent_set) then
        vim.bo[buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
      end
    end,
  })
end)
