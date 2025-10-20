local MiniDeps = require('mini.deps')

local function build_blink(params)
  vim.notify('Building blink.cmp', vim.log.levels.INFO)
  local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building blink.cmp done', vim.log.levels.INFO)
  else
    vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end
end

MiniDeps.later(function()
  MiniDeps.add({
    source = 'Saghen/blink.cmp',
    -- depends = { 'rafamadriz/friendly-snippets' },
    hooks = {
      post_install = build_blink,
      post_checkout = build_blink,
    },
  })
  require('blink.cmp').setup({
    enabled = function()
      return (
        not vim.g.cmp_disable and
        not vim.tbl_contains({ "markdown", "minifiles" }, vim.bo.filetype)
      )
    end,
    completion = {
      menu = {
        auto_show = false,
        draw = { columns = {{ "label" }, { "kind_icon", "kind", gap = 1 }} },
      },
      ghost_text = { enabled = true , show_with_menu = true },
      list = { selection = { auto_insert = false }}
    },
    keymap = {
      preset = 'none',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<tab>'] = { 'select_and_accept', 'fallback' },

      ['<C-n>'] = {
        function(cmp)
          if not cmp.is_menu_visible() then
            cmp.show({ initial_selected_item_idx = 2})
          end
        end,
        'select_next',
        'fallback_to_mappings'
      },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },

      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },

      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    signature = { enabled = true }, -- experimental
  })
end)

-- sources = {
--   providers = {
--     cmdline = {
--       -- ignores cmdline completions when executing shell commands
--       enabled = function()
--         return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
--       end,
--     },
--     lsp = {
--       name = 'lsp',
--       module = 'blink.cmp.sources.lsp',
--       transform_items = function (_, items)
--         return vim.tbl_filter(function (item)
--           return item.kind ~= require('blink.cmp.types').completionitemkind.keyword
--         end, items)
--       end
--     }
--   },
-- },

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'BlinkCmpMenuOpen',
--   callback = function()
--     require("copilot.suggestion").dismiss()
--     vim.b.copilot_suggestion_hidden = true
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'BlinkCmpMenuClose',
--   callback = function()
--     vim.b.copilot_suggestion_hidden = false
--   end,
-- })
