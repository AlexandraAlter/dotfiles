" vim:fileencoding=utf-8:foldmethod=marker

" {{{ general
set nocompatible
set mouse=a
set spelllang=en_us,cjk
set spellsuggest=best,9

set timeoutlen=500

let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" " sensible
" " obsession

" }}}

" {{{ interface
highlight PMenu ctermfg=7* ctermbg=0

" " airline
" " characterize

" }}}

" {{{ navigation
set ignorecase
set smartcase
set foldopen=hor,mark,percent,quickfix,search,tag,undo
set foldenable

" " targets (+targets-camels)
" " sneak
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
"let g:UltiSnipsExpandTrigger=""
"let g:UltiSnipsJumpForwardTrigger=""
"let g:UltiSnipsJumpBackwardTrigger=""

" }}}

" {{{ completion
set completeopt=menu,menuone,noinsert,noselect

" " cmp (+cmp-*)
lua <<EOF
  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local cmp = require('cmp')
  local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')

  cmp.setup({
    snippet = {
      expand = function(args) vim.fn['UltiSnips#Anon'](args.body) end,
    },

    mapping = {
      ['<Tab>'] = cmp.mapping({
        c = function()
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end,
        i = function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
          else
            fallback()
          end
        end,
        s = function(fallback)
          if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
          else
            fallback()
          end
        end,
      }),

      ["<S-Tab>"] = cmp.mapping({
        c = function()
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end,
        i = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
            return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
          else
            fallback()
          end
        end,
        s = function(fallback)
          if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
            return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
          else
            fallback()
          end
        end,
      }),

      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),

      ['<C-n>'] = cmp.mapping({
        c = function()
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
          end
        end,
        i = function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end,
      }),

      ['<C-p>'] = cmp.mapping({
        c = function()
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
            vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
          end
        end,
        i = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end,
      }),

      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
      ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
      ['<C-y>'] = cmp.config.disable,

      ['<CR>'] = cmp.mapping({
        i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        c = function(fallback)
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
            fallback()
          end
        end,
      }),
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
command -bar ConfigReload source $MYVIMRC | echo 'Sourced' $MYVIMRC
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
let g:floaterm_autoclose     = 1

tnoremap <silent> <C-z> <Cmd>FloatermHide<CR>
nnoremap <silent> <F7> <Cmd>FloatermNew<CR>
tnoremap <silent> <F7> <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <F8> <Cmd>FloatermPrev<CR>
tnoremap <silent> <F8> <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <F9> <Cmd>FloatermNext<CR>
tnoremap <silent> <F9> <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <F10> <Cmd>FloatermToggle<CR>
tnoremap <silent> <F10> <C-\><C-n>:FloatermToggle<CR>

" " neomake
" " tbone
" " fugitive

" }}}

" {{{ formats
setlocal ts=2 sts=2 sw=2 et makeprg=make
autocmd FileType * setlocal ts=2 sts=2 sw=2 et

autocmd FileType c setlocal equalprg=clang-format cino=N-s\ g0
autocmd FileType cpp setlocal equalprg=clang-format cino=N-s\ g0
autocmd FileType python setlocal equalprg=yapf
autocmd FileType javascript setlocal equalprg=prettier\ --stdin-filepath\ %
autocmd FileType typescript setlocal equalprg=prettier\ --stdin-filepath\ %

let g:markdown_folding=1
autocmd FileType markdown setlocal foldlevel=1

" " sleuth
" " enuch
" " ragtag (xml)
" " jdaddy (json)

" " endwise
" " unimpaired

" " lspconfig
lua <<EOF
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
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
      q = { '<Cmd>quit<CR>', 'Quit' },
    },

    j = {
      name = '+jump',
    },

    f = {
      name = '+file',
      f = { '<Cmd>Telescope files<CR>', 'Telescope' },
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
        r = { '<Cmd>ConfigReload<CR>', 'Reload' },
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
    },

    t = {
      name = '+toggle',
      t = { '<Cmd>FloatermToggle<CR>', 'Terminal' },
      s = { '<Cmd>set spell!<CR>', 'Spelling' },
      c = { '<Cmd>lua CmpToggle<CR>', 'Completion' },
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
EOF
" }}}

" {{{ discarded
" emmet
" syntastic
" }}}

