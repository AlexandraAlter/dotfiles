" vim:fileencoding=utf-8:foldmethod=marker

" {{{ libraries/frameworks

" " {{{ lspconfig
" " }}}

" }}}

" {{{ general
set nocompatible
set mouse=a

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

" " {{{ which-key
set timeoutlen=500
let g:which_key_global_map = {}

let g:mapleader = "\<Space>"
nnoremap <silent> <Leader> <Cmd>WhichKey '<Space>'<CR>
"inoremap <silent> <C-i>    <Cmd>WhichKey '<Space>'<CR>
call which_key#register('<Space>', 'g:which_key_leader_map')
let g:which_key_leader_map = {}

let g:maplocalleader = ','
nnoremap <silent> <LocalLeader> :<c-u>WhichKey ','<CR>
call which_key#register(',', 'g:which_key_local_map')
let g:which_key_local_map = {}

"nnoremap <silent> g :<c-u>WhichKey 'g'<CR>
"call which_key#register('g', 'g:which_key_g_map')
"let g:which_key_g_map = {
      "\ 'a': 'get-ascii',
      "\ '8': 'get-hex',
      "\ }

"nnoremap ga ga
"nnoremap g8 g8

let g:which_key_leader_map.b = { 'name': '+buffers' }
let g:which_key_leader_map.s = { 'name': '+search' }
let g:which_key_leader_map.q = { 'name': '+quit' }
let g:which_key_leader_map.t = { 'name': '+text' }
let g:which_key_leader_map.j = { 'name': '+jump' }
let g:which_key_leader_map.n = { 'name': '+numbers' }
" " }}}

" }}}

" {{{ navigation
set foldopen=hor,mark,percent,quickfix,search,tag,undo
set ignorecase
set smartcase

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
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
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
let g:UltiSnipsExpandTrigger=""
let g:UltiSnipsJumpForwardTrigger=""
let g:UltiSnipsJumpBackwardTrigger=""
" " }}}

" " {{{ snippets
" " }}}

" }}}

" {{{ completion

" " {{{ cmp
set completeopt=menu,menuone,noselect

lua <<EOF
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable,
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(
        function(fallback)
          cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
        end,
        { 'i', 's', 'c' }
      ),
      ['<S-Tab>'] = cmp.mapping(
        function(fallback)
          cmp_ultisnips_mappings.jump_backwards(fallback)
        end,
        { 'i', 's', 'c' }
      ),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
    }, {
      { name = 'buffer' },
    })
  })

  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --   capabilities = capabilities
  -- }
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

autocmd FileType javascript setlocal ts=2 sts=2 sw=2 et
autocmd FileType coffee setlocal ts=2 sts=2 sw=2 et makeprg=make
autocmd FileType nim setlocal makeprg=make
autocmd FileType rust setlocal ts=2 sts=2 sw=2 et
autocmd FileType typescript setlocal ts=2 sts=2 sw=2 et makeprg=make formatprg=prettier\ --parser\ typescript
autocmd FileType html setlocal ts=2 sts=2 sw=2 et

autocmd FileType python nnoremap <LocalLeader>= m`:0,$!yapf<CR>``

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
let g:which_key_leader_map.f = {
      \ 'name': '+files',
      \ 's': 'write',
      \ 'w': 'write',
      \ 'S': {
      \   'name': '+sudo',
      \   'e': 'edit',
      \   's': 'write',
      \   'w': 'write',
      \ },
      \ 'c': {
      \   'name': '+config',
      \   'r': 'reload',
      \   'e': 'edit',
      \ },
      \ 'r': '?recent',
      \ 'R': '?rename',
      \ 'f': 'find',
      \ }

nnoremap <silent> <Leader>fs <Cmd>write<CR>
nnoremap <silent> <Leader>fw <Cmd>write<CR>
nnoremap <silent> <Leader>ff <Cmd>Explore<CR>

nnoremap <silent> <Leader>fcr <Cmd>source $MYVIMRC<CR><Cmd>echo 'Sourced' $MYVIMRC<CR>
nnoremap <silent> <Leader>fce <Cmd>edit $MYVIMRC<CR>

nnoremap <silent> <Leader>fSe <Cmd>SudoEdit<CR>
nnoremap <silent> <Leader>fSs <Cmd>SudoWrite<CR>
nnoremap <silent> <Leader>fSw <Cmd>SudoWrite<CR>

" " {{{ projectionist
" " }}}

" " {{{ vinegar
" " }}}

" " {{{ enuch
" " }}}

" " {{{ telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" " }}}

" " {{{ telescope-fzf-native
lua require('telescope').load_extension('fzf')
" " }}}

" }}}

" {{{ windows
let g:which_key_leader_map.w = {
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
let g:which_key_leader_map.a = {
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


