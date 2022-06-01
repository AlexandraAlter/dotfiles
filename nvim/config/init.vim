" vim:fileencoding=utf-8:foldmethod=marker

" {{{ libraries/frameworks

" " {{{ lspconfig
" " }}}

" }}}

" {{{ general
set nocompatible
set mouse=a
set spelllang=en_us,cjk
set spellsuggest=best,9

" " {{{ sensible
" " }}}

" " {{{ obsession
" " }}}

" }}}

" {{{ interface
highlight PMenu ctermfg=7* ctermbg=0

" " {{{ airline
" " }}}

" " {{{ web-devicons
" used by telescope
" " }}}

" " {{{ characterize
" " }}}

" }}}

" " {{{ which-key
set timeoutlen=500

let g:mapleader = "\<Space>"
let g:maplocalleader = ','

nnoremap <silent> <Leader>      <Cmd>WhichKey       '<Space>'<CR>
vnoremap <silent> <Leader>      <Cmd>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <LocalLeader> <Cmd>WhichKey       ','<CR>
vnoremap <silent> <LocalLeader> <Cmd>WhichKeyVisual ','<CR>

call which_key#register('<Space>', 'g:leader_map')
call which_key#register(',', 'g:local_map')

let g:leader_map = {
      \ 'a': { 'name': '+apps' },
      \ 'q': { 'name': '+quit' },
      \ 'j': { 'name': '+jump' },
      \ 'f': { 'name': '+files' },
      \ 'b': { 'name': '+buffers' },
      \ 'h': { 'name': '+help' },
      \ 't': { 'name': '+toggle' },
      \ 'x': { 'name': '+text' },
      \ 'w': { 'name': '+windows' },
      \ 'n': { 'name': '+numeric' },
      \ 's': { 'name': '+search' },
      \ }

let g:local_map = {
      \ '=': [ 'm`gg=G``', 'reformat' ],
      \ }

"nnoremap <LocalLeader>= m`gg=G``

let g:leader_map.b.1 = [':b1', 'buffer 1']
let g:leader_map.b.2 = [':b2', 'buffer 2']

      " 'd' : ['bd',        'delete-buffer'],
      " 'f' : ['bfirst',    'first-buffer'],
      " 'l' : ['blast',     'last-buffer'],
      " 'n' : ['bnext',     'next-buffer'],
      " 'p' : ['bprevious', 'previous-buffer'],

" }}}

" {{{ navigation
set ignorecase
set smartcase
set foldopen=hor,mark,percent,quickfix,search,tag,undo
set foldenable
let g:markdown_folding=1
autocmd FileType markdown setlocal foldlevel=1

nnoremap <silent> <Leader>wk <C-w>k
nnoremap <silent> <Leader>wj <C-w>j
nnoremap <silent> <Leader>wl <C-w>l
nnoremap <silent> <Leader>wh <C-w>h

nnoremap <silent> <Leader>wK <C-w>K
nnoremap <silent> <Leader>wJ <C-w>J
nnoremap <silent> <Leader>wL <C-w>L
nnoremap <silent> <Leader>wH <C-w>H

nnoremap <silent> <Leader>w= <C-w>=

" " {{{ targets
" " }}}

" " {{{ targets-camels
" " }}}

" " {{{ sneak
" " }}}

" }}}

" {{{ editing

" " {{{ easy-align
let g:leader_map.x.a = ['<Plug>(EasyAlign)', 'align']
xmap gA <Plug>(EasyAlign)
nmap gA <Plug>(EasyAlign)
" " }}}

" " {{{ repeat
" " }}}

" " {{{ surround
" " }}}

" " {{{ commentary
" " }}}

" " {{{ abolish
" " }}}

" " {{{ speeddating
" " }}}

" " {{{ ultisnips
"let g:UltiSnipsExpandTrigger=""
"let g:UltiSnipsJumpForwardTrigger=""
"let g:UltiSnipsJumpBackwardTrigger=""
" " }}}

" " {{{ snippets
" " }}}

" }}}

" {{{ completion

" " {{{ cmp
set completeopt=menu,menuone,noinsert,noselect

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

      ['<C-y>'] = cmp.config.disable,
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

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  local lsp = require('lspconfig')
  -- lsp['eslint'].setup { capabilities = capabilities }

  local cmp_enabled = true
  function CmpToggle()
    cmp_enabled = not cmp_enabled
    cmp.setup.buffer { enabled = cmp_enabled }
  end
EOF

" " }}}

" " {{{ cmp-buffer
" " }}}

" " {{{ cmp-cmdline
" " }}}

" " {{{ cmp-lsp
" " }}}

" " {{{ cmp-path
" " }}}

" " {{{ cmp-ultisnips
" " }}}

" }}}

" {{{ formats
setlocal ts=2 sts=2 sw=2 et
setlocal makeprg=make
autocmd FileType * setlocal ts=2 sts=2 sw=2 et

autocmd FileType python setlocal equalprg=yapf
autocmd FileType javascript setlocal equalprg=prettier\ --stdin-filepath\ %
autocmd FileType typescript setlocal equalprg=prettier\ --stdin-filepath\ %
autocmd FileType cpp setlocal equalprg=clang-format cino=N-s\ g0
autocmd FileType c setlocal equalprg=clang-format cino=N-s\ g0

" " {{{ sleuth
" " }}}

" " {{{ enuch
" " }}}

" " {{{ ragtag (xml)
" " }}}

" " {{{ jdaddy (json)
" " }}}

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

"" {{{ files
let g:leader_map.f.s = [':update', 'save']

let g:leader_map.f.c = { 'name': '+config' }
let g:leader_map.f.c.e = [':edit $MYVIMRC', 'edit']
let g:leader_map.f.c.r = [':ConfigReload', 'reload']
command -bar ConfigReload source $MYVIMRC | echo 'Sourced' $MYVIMRC

let g:leader_map.f.S = { 'name': '+sudo' }
let g:leader_map.f.S.e = [':SudoEdit', 'edit']
let g:leader_map.f.S.s = [':SudoWrite', 'save']

" " {{{ projectionist
" " }}}

" " {{{ vinegar
" " }}}

" " {{{ enuch
call extend(g:leader_map.f, { 'R': 'rename', 'M': 'move', 'C': 'chmod', 'D': 'mkdir' })
nnoremap <silent> <Leader>fR <Cmd>call feedkeys(':Rename ')<CR>
nnoremap <silent> <Leader>fM <Cmd>call feedkeys(':Move ')<CR>
nnoremap <silent> <Leader>fC <Cmd>call feedkeys(':Chmod ')<CR>
nnoremap <silent> <Leader>fD <Cmd>call feedkeys(':Mkdir ')<CR>
let g:leader_map.f.W = [':Wall', 'write all']
" " }}}

" " {{{ telescope
let g:leader_map.f.r = [':Telescope oldfiles', 'recent']
let g:leader_map.f.f = [':Telescope find_files', 'find']
let g:leader_map.b.b = [':Telescope buffers', 'find']
let g:leader_map.h.h = [':Telescope help_tags', 'find']
let g:leader_map.s.s = [':Telescope live_grep', 'search']
" " }}}

" " {{{ telescope-fzf-native
lua require('telescope').load_extension('fzf')
" " }}}

" }}}

" {{{ windows
let g:leader_map.w = {
      \ 'name': '+windows',
      \ 'k': 'up',
      \ 'j': 'down',
      \ 'l': 'right',
      \ 'h': 'left',
      \ 'K': 'move up',
      \ 'J': 'move down',
      \ 'L': 'move right',
      \ 'H': 'move left',
      \ '=': 'balance',
      \ }
" }}}

" {{{ integration
let g:leader_map.a = {
      \ 'name': '+apps',
      \ 'f': {
      \   'name': '+float',
      \   't': 'toggle',
      \   's': 'shell',
      \   'r': 'ranger',
      \   'p': 'python',
      \ },
      \ 'g': 'git',
      \ 's': 'shell',
      \ 'r': 'ranger',
      \ 'p': 'python',
      \ }

command -bar PackUpdate execute vertical topleft new cd stdpath('data') . '/site/pack' | Git submodule update '--remote' '--merge' '--recursive' .

" " {{{ tbone
" " }}}

" " {{{ floaterm
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F10>'
let g:floaterm_autoclose     = 1

nnoremap <silent> <Leader>as <Cmd>FloatermNew<CR>
nnoremap <silent> <Leader>ar <Cmd>FloatermNew ranger<CR>
nnoremap <silent> <Leader>ap <Cmd>FloatermNew python<CR>

nnoremap <silent> <Leader>ag <Cmd>call feedkeys(':Git ')<CR>

nnoremap <silent> <Leader>aft <Cmd>FloatermToggle<CR>
nnoremap <silent> <Leader>afs <Cmd>FloatermNew<CR>
nnoremap <silent> <Leader>afr <Cmd>FloatermNew ranger<CR>
nnoremap <silent> <Leader>afp <Cmd>FloatermNew python<CR>

tnoremap <silent> <C-z> <Cmd>FloatermHide<CR>

nnoremap <silent> <F7> <Cmd>FloatermNew<CR>
tnoremap <silent> <F7> <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <F8> <Cmd>FloatermPrev<CR>
tnoremap <silent> <F8> <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <F9> <Cmd>FloatermNext<CR>
tnoremap <silent> <F9> <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <F10> <Cmd>FloatermToggle<CR>
tnoremap <silent> <F10> <C-\><C-n>:FloatermToggle<CR>
" " }}}

" " {{{ neomake
" " }}}

" }}}


" " {{{ endwise
" " }}}
" " {{{ unimpaired
" " }}}
" " {{{ fugitive
" " }}}

" }}}

" {{{ toggles
let g:leader_map.t.s = [':set spell!', 'spelling']
let g:leader_map.t.c = [':lua CmpToggle\(\)', 'completion']
" }}}

" {{{ discarded
" wordmotion
" easymotion
" YouCompleteMe
" deoplete
" emmet
" coc
" denite
" ctrlp
" fzf
" fzf.vim
" ack.vim
" ctrlspace
" Command-T
" fzf-floaterm
" syntastic
" wiki.vim
" vimwiki
" vim-notes
" vim-misc
" vim-lua-ftplugin
" rust.vim
" vim-coffee-script
" typescript-vim
" julia-vim
" vim-toml
" python-mode
" }}}


