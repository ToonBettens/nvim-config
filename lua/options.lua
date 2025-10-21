
--  ( General ) ================================================================
vim.g.mapleader = ' '
vim.cmd.filetype('plugin indent on') -- Enable all filetype plugins

--  ( Buffers & Persistance ) ==================================================
vim.opt.switchbuf      = 'usetab'   -- Use already opened buffers when switching
vim.opt.undofile       = true       -- Enable persistent undo
vim.opt.undolevels     = 1000       -- Undo history
vim.opt.backup         = false      -- Don't store backup
vim.opt.writebackup    = false      -- Don't store backup (2)

-- ( Clipboard ) ===============================================================
-- https://github.com/memoryInject/wsl-clipboard
local function is_wsl()
  local version_file = io.open("/proc/version", "rb")
  if version_file ~= nil and string.find(version_file:read("*a"), "microsoft") then
    version_file:close()
    return true
  end
  return false
end

if is_wsl() then
  vim.g.clipboard = {
    name = 'wsl-clipboard',
    copy = {
      ['+'] = 'wcopy',
      ['*'] = 'wcopy',
    },
    paste = {
      ['+'] = 'wpaste',
      ['*'] = 'wpaste',
    },
    cache_enabled = true,
  }
else  -- fallback to osc52
  vim.g.clipboard = 'osc52'
end


--  ( Text Layout ) ============================================================
vim.opt.wrap           = false      -- No soft wrap
vim.opt.linebreak      = true       -- Break on 'breakat' chars when wrapping
vim.opt.breakindent    = true       -- Preserve indent when wrapping
vim.opt.breakindentopt = 'list:-1'  -- Extra padding for wrapped list items
vim.opt.list           = true       -- Show helpful character indicators (defined by 'listchars')
vim.opt.listchars = { extends='…', nbsp='␣', precedes='…', tab='→ ', trail='·' }

--  ( Interface & Display ) ====================================================
vim.opt.number         = true       -- Show line numbers
vim.opt.relativenumber = true       -- Enable relative line numbers
vim.opt.ruler          = true       -- Show ruler in statusline
vim.opt.signcolumn     = 'yes:1'     -- Show signcolumn only when there is a sign to display
vim.opt.textwidth      = 0          -- Disable maximum textwidth
vim.opt.colorcolumn    = '+1'       -- Show colorcolumn after 'textwidth'
vim.opt.virtualedit    = 'block'    -- Allow cursor in visual block past EOL
vim.opt.shortmess      = 'aOWcCF'   -- Surpress some messages
vim.opt.mouse          = 'a'        -- Enable mouse
vim.opt.splitbelow     = true       -- Horizontal splits downwards
vim.opt.splitright     = true       -- Vertical splits to the right
vim.opt.scrolloff      = 10         -- Keep context above/below cursor
vim.opt.sidescrolloff  = 10         -- Keep context left/right of cursor

--  ( Indentation ) ============================================================
vim.opt.expandtab      = true       -- Use spaces instead of tabs
vim.opt.shiftwidth     = 2          -- Spaces per indent
vim.opt.tabstop        = 2          -- Spaces per tab
-- vim.opt.smartindent    = true       -- Smarter indenting
vim.opt.autoindent     = true       -- Continue indent on new line
vim.opt.formatoptions:remove({'c', 'o'}) -- Disable auto-wrap and auto-comment on 'o' and 'O'
vim.api.nvim_create_autocmd('FileType', {
  callback = function() vim.opt_local.formatoptions:remove({ 'c', 'o' }) end
})

--  ( Navigation, Search & Substitute ) ========================================
vim.opt.ignorecase     = true       -- Ignore case in search patterns
vim.opt.smartcase      = true       -- Don't ignore case if search has capitals
vim.opt.incsearch      = true       -- Show matches while typing
vim.opt.inccommand     = 'split'    -- Show preview for substitute (:s) operations
vim.opt.hlsearch       = false      -- Don't highlight search results

--  ( Completion ) =============================================================
vim.opt.pumheight      = 10         -- Vertically limit popup menu height

--  ( Spelling ) ===============================================================
vim.opt.spelllang      = 'en_gb'    -- Define spelling dictionaries
vim.opt.spelloptions   = 'camel'    -- Treat parts of camelCase words as separate words

--  ( Folds ) ==================================================================
vim.opt.foldmethod     = 'indent'   -- Set 'indent' folding method
vim.opt.foldlevel      = 99         -- Folds are open unless manually closed
vim.opt.foldnestmax    = 10         -- Create folds only for some number of nested levels
vim.opt.foldtext       = ''         -- Use underlying text with its highlighting

--  ( Diagnostics ) ============================================================
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  virtual_lines = false,
  signs = true,
  float = true,
})
