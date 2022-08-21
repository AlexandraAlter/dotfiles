" vim:fileencoding=utf-8:foldmethod=marker

" {{{ general
set nocompatible
set mouse=a
set mousemodel=extend
set spelllang=en_us,cjk
set spellsuggest=best,9

set timeoutlen=500

let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" " sensible
" " obsession

" }}}

" {{{ interface
highlight PMenu ctermfg=Cyan ctermbg=DarkGrey guifg=Cyan guibg=DarkGrey

" " airline
" " characterize

" }}}

" {{{ navigation
set ignorecase
set smartcase
set foldopen=hor,insert,jump,mark,percent,quickfix,search,tag,undo
set foldenable
let g:markdown_folding=1

command! BW :bn|:bd#

" " sneak
nnoremap \ <Plug>Sneak_,

" " targets
" " wordmotion

" }}}

" {{{ editing
" " easy-align
xmap gA <Plug>(EasyAlign)
nmap gA <Plug>(EasyAlign)

" " repeat
" " surround
" " commentary
" " abolish
" " speeddating
" " snippets

" " ultisnips
let g:UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
let g:UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
let g:UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
let g:UltiSnipsListSnippets = '<c-x><c-s>'
let g:UltiSnipsRemoveSelectModeMappings = 0

" }}}

" {{{ completion
set completeopt=menu,menuone,noinsert,noselect

" " cmp (+cmp-*)
lua <<EOF
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
EOF

" }}}

" {{{ filesystem
set swapfile
set undofile
set backup
set backupdir-=.
if !isdirectory(expand(stdpath('data') . '/backup'))
  call mkdir(expand(stdpath('data') . '/backup'), 'p')
endif
let g:netrw_home=expand(stdpath('data'))

" " files
command -bar Reload source $MYVIMRC | echo 'Sourced' $MYVIMRC
command -bar PackUpdate execute vertical topleft new cd stdpath('data') . '/site/pack' | Git submodule update '--remote' '--merge' '--recursive' .

" " telescope (+telescope-fzf-native +web-devicons)
lua require('telescope').load_extension('fzf')

" " projectionist
" " vinegar
" " enuch

" }}}

" {{{ integration

" " floaterm
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F10>'
let g:floaterm_keymap_hide   = '<C-z>'
let g:floaterm_autoclose     = 1

" " neomake
" " tbone
" " fugitive

" }}}

" {{{ formats
set ts=2 sts=2 sw=2 et makeprg=make

autocmd FileType python setlocal equalprg=yapf
autocmd FileType javascript setlocal equalprg=prettier\ --stdin-filepath\ %
autocmd FileType typescript setlocal equalprg=prettier\ --stdin-filepath\ %

autocmd FileType markdown setlocal foldlevel=1

" " eunuch

" " sleuth
" " endwise
" " unimpaired

" " ragtag (xml)
" " jdaddy (json)

" " lspconfig
lua <<EOF
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  local lsp = require('lspconfig')
  -- lsp['eslint'].setup { capabilities = capabilities }
EOF

" }}}

" {{{ which-key
lua <<EOF
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
EOF
" }}}

" {{{ discarded
" emmet
" syntastic
" }}}

