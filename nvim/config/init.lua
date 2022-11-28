-- lua:fileencoding=utf-8:foldmethod=marker

local data = vim.fn.expand(vim.fn.stdpath('data'))

-- {{{ general
vim.opt.compatible = false
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'extend'
vim.opt.spelllang = 'en_us,cjk'
vim.opt.spellsuggest = 'best,9'

vim.opt.timeoutlen = 500

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- -- sensible
-- -- obsession

-- }}}

-- {{{ interface
vim.api.nvim_set_hl(0, 'PMenu', {
  fg='Cyan', bg='DarkGrey', ctermfg='Cyan', ctermbg='DarkGrey'
})
if vim.fn.exists('g:neovide') then
  vim.opt.guifont = 'Fira Code,Fira Code Nerd:h14'
end

-- -- airline
-- -- characterize

-- }}}

-- {{{ navigation
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.foldopen = 'hor,insert,jump,mark,percent,quickfix,search,tag,undo'
vim.opt.foldenable = true
vim.g.markdown_folding = 1

vim.cmd('command! BW :bn|:bd#')

-- -- sneak
vim.keymap.set('n', '\\', '<Plug>Sneak_,')

-- -- targets
-- -- wordmotion

-- }}}

-- {{{ editing
-- -- easy-align
vim.keymap.set('x', 'gA', '<Plug>EasyAlign')
vim.keymap.set('n', 'gA', '<Plug>EasyAlign')

-- -- repeat
-- -- surround
-- -- commentary
-- -- abolish
-- -- speeddating
-- -- snippets

-- -- ultisnips
vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
vim.g.UltiSnipsRemoveSelectModeMappings = 0

-- }}}

-- {{{ completion
vim.opt.completeopt = 'menu,menuone,noinsert,noselect'

-- -- cmp (+cmp-*)
local cmp = require('cmp')
local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')

cmp.setup({
  snippet = {
    expand = function(args) vim.fn['UltiSnips#Anon'](args.body) end,
  },

  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),

    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),

    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(
    function(fallback)
      cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
    end,
    { 'i', 's' }
    ),
    ['<S-Tab>'] = cmp.mapping(
    function(fallback)
      cmp_ultisnips_mappings.jump_backwards(fallback)
    end,
    { 'i', 's' }
    ),
    ['<C-e>'] = cmp.mapping.close(),
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'buffer', keyword_length = 3 },
  })
})

cmp.setup.cmdline('/', {
  completion = { autocomplete = false },
  sources = {
    { name = 'buffer', keyword_pattern = [=[[^[:blank:]].*]=] }
  }
})

cmp.setup.cmdline(':', {
  completion = { autocomplete = false },
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local cmp_enabled = true
function CmpToggle()
  cmp_enabled = not cmp_enabled
  cmp.setup.buffer { enabled = cmp_enabled }
end

-- }}}

-- {{{ filesystem
vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.backup = true
vim.opt.backupdir:remove('.')
if not vim.fn.isdirectory(data .. '/backup') then
  vim.fn.mkdir(data .. '/backup')
end
vim.g.netrw_home = data

-- -- files
vim.cmd [[command! -bar Reload source $MYVIMRC | echo 'Sourced' $MYVIMRC]]
vim.cmd [[command! -bar PackUpdate exe 'vert topleft new cd' stdpath('data') . '/site/pack | Git submodule update --remote --merge --recursive .']]

-- -- telescope (+telescope-fzf-native +web-devicons)
local telescope = require('telescope')
telescope.load_extension('fzf')

-- -- projectionist
-- -- vinegar
-- -- enuch

-- }}}

-- {{{ integration

-- -- floaterm
vim.g.floaterm_keymap_new    = '<F6>'
vim.g.floaterm_keymap_toggle = '<F5>'
vim.g.floaterm_keymap_prev   = '<F7>'
vim.g.floaterm_keymap_next   = '<F8>'
vim.g.floaterm_keymap_hide   = '<C-z>'
vim.g.floaterm_autoclose     = 1

-- -- neomake
-- -- tbone
-- -- fugitive

-- }}}

-- {{{ formats
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.et = true
vim.opt.makeprg = 'make'

-- -- eunuch

-- -- sleuth
-- -- endwise
-- -- unimpaired

-- -- ragtag (xml)
-- -- jdaddy (json)
-- -- godot (gdscript)

-- -- lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
-- lsp['eslint'].setup { capabilities = capabilities }

-- }}}

-- {{{ which-key
local wk = require('which-key')

wk.register({
  a = {
    name = '+app',
    s = { '<Cmd>FloatermNew<CR>', 'Shell' },
    r = { '<Cmd>FloatermNew ranger<CR>', 'Ranger' },
    p = { '<Cmd>FloatermNew python<CR>', 'Python' },
    j = { '<Cmd>FloatermNew julia<CR>', 'Julia' },
    g = { '<Cmd>call feedKeys(\':Git \')<CR>', 'Git' },
    t = {
      name = 'Tmux',
      a = { '<Cmd>Tattach<CR>', 'Attach' },
      y = { '<Cmd>Tyank<CR>', 'Yank' },
      p = { '<Cmd>Tput<CR>', 'Put' },
      w = { '<Cmd>Twrite<CR>', 'Write' },
    },
    T = { '<Cmd>call feedKeys(\':Tmux \')<CR>', 'Tmux' },
  },

  q = {
    name = '+quit',
    q = { '<Cmd>quitall<CR>', 'Quit' },
    Q = { '<Cmd>quit<CR>', 'Quit This' },
    w = { '<Cmd>wqall<CR>', 'Write and Quit' },
    W = { '<Cmd>wq<CR>', 'Write and Quit This' },
  },

  j = {
    name = '+jump',
    j = { '<Cmd>Telescope marks<CR>', 'Telescope' },
    d = { '<Cmd>delmarks!<CR>', 'Delete Marks' },
    D = { '<Cmd>delmarks A-Z0-9<CR>', 'Delete All Marks' },
  },

  f = {
    name = '+file',
    f = { '<Cmd>Telescope find_files<CR>', 'Telescope' },
    r = { '<Cmd>Telescope oldfiles<CR>', 'Recent' },
    s = { '<Cmd>write<CR>', 'Save' },
    S = { '<Cmd>wall<CR>', 'Save All' },
    R = { '<Cmd>call feedkeys(\':Rename \')<CR>', 'Rename' },
    M = { '<Cmd>call feedkeys(\':Move \')<CR>', 'Move' },
    C = { '<Cmd>call feedkeys(\':Chmod \')<CR>', 'Chmod' },
    D = { '<Cmd>call feedkeys(\':Mkdir \')<CR>', 'Mkdir' },
    c = {
      name = '+config',
      e = { '<Cmd>edit $MYVIMRC<CR>', 'Edit' },
      r = { '<Cmd>Reload<CR>', 'Reload' },
    },
    F = {
      name = '+sudo',
      e = { '<Cmd>SudoEdit<CR>', 'Edit' },
      s = { '<Cmd>SUdoWrite<CR>', 'Save' },
    },
  },

  b = {
    name = '+buffer',
    b = { '<Cmd>Telescope buffers<CR>', 'Telescope' },
    ['1'] = { '<Cmd>b1<CR>', 'Buffer 1' },
    ['2'] = { '<Cmd>b2<CR>', 'Buffer 2' },
    f = { '<Cmd>bfirst<CR>', 'First' },
    l = { '<Cmd>blast<CR>', 'Last' },
    n = { '<Cmd>bnext<CR>', 'Next' },
    p = { '<Cmd>bprevious<CR>', 'Previous' },
    d = { '<Cmd>bd<CR>', 'Delete' },
    D = { '<Cmd>BW<CR>', 'Delete and Next' },
  },

  t = {
    name = '+toggle',
    t = { '<Cmd>FloatermToggle<CR>', 'Term' },
    c = { '<Cmd>lua CmpToggle()<CR>', 'Completion' },
    s = { '<Cmd>set spell!<CR>', 'Spell' },
    w = { '<Cmd>set wrap!<CR>', 'Wrap' },
  },

  x = {
    name = '+text',
  },

  n = {
    name = '+number',
  },

  g = {
    name = '+git',
    g = { '<Cmd>call feedKeys(\':Git \')<CR>', 'Git' },
  },

  s = {
    name = '+search',
    s = { '<Cmd>Telescope live_grep<CR>', 'Telescope' },
    c = { '<Cmd>nohlsearch<CR>', 'Clear' },
  },

  h = {
    name = '+help',
    h = { '<Cmd>Telescope help_tags<CR>', 'Telescope' },
  },

  w = { '<Cmd>WhichKey <C-w><CR>', '+window' },
}, { prefix = '<leader>' })

wk.register({
  ['='] = { 'm`gg=G``', 'reformat' },
}, { prefix = '<localleader>' })

wk.register({
  name = 'window',

  h = 'Go to the left window',
  l = 'Go to the right window',
  k = 'Go to the up window',
  j = 'Go to the down window',
  t = 'Go to the top window',
  b = 'Go to the bottom window',
  w = 'Next window',
  p = 'Previous window',
  W = 'Previous window',

  ['-'] = 'Decrease height',
  ['+'] = 'Increase height',
  ['<lt>'] = 'Decrease width',
  ['>'] = 'Increase width',
  ['='] = 'Equalize windows',
  ['_'] = 'Set height',
  ['|'] = 'Set width',

  H = 'Move window left',
  L = 'Move window right',
  K = 'Move window up',
  J = 'Move window down',
  P = 'Previous window',
  r = 'Rotate windows downwards',
  R = 'Rotate windows upwards',
  x = 'Exchange windows',

  n = 'New window',
  s = 'Split window',
  v = 'Split window vertically',
  T = 'Break out into a new tab',
  d = 'Jump to definition in a window',
  i = 'Jump to identifier in a window',
  f = 'Edit file name in a window',
  [']'] = 'Jump to tag in a window',
  ['}'] = 'Jump to tag with a preview',
  ['^'] = 'Edit alternate file in a window',

  o = 'Keep only this window',
  c = 'Close window',
  q = 'Quit window',

  g = {
    name = 'g',
    ['C-]'] = ':tjump in a window',
    [']'] = ':tselect in a window',
    ['}'] = ':ptjump in a window',
    f = 'Edit file name in a tab',
    F = 'Edit file name and line number in a tab',
    t = 'Next tab',
    T = 'Previous tab',
    ['<Tab>'] = 'Last tab',
  },
}, { prefix = '<C-w>' })

wk.register({
  name = 'z',

  u = {
    name = 'Undo',
    w = 'Undo zw',
    g = 'Undo zg',
    W = 'Undo zW',
    G = 'Undo zG',
  },
}, { prefix = 'z' })
-- }}}

-- {{{ discarded
-- emmet
-- syntastic
-- }}}

