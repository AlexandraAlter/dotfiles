" vim:fileencoding=utf-8:foldmethod=marker

" {{{ general
set nocompatible
set encoding=utf-8
" }}}

" {{{ plugins
if empty(glob(stdpath('data') . '/site/autoload/plug.vim'))
  execute 'silent !curl -fLo' . stdpath('data') . '/site/autoload/plug.vim --create-dirs'
    \ . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

"" {{{ General
Plug 'tpope/vim-sensible'
"" }}}

"" {{{ libraries
Plug 'xolox/vim-misc' " needed for xolox/vim-lua-ftplugin
"" }}}

"" {{{ interface/information
Plug 'tpope/vim-characterize'
Plug 'liuchengxu/vim-which-key'
"Plug 'tpope/vim-flagship'
Plug 'vim-airline/vim-airline'
"" }}}

"" {{{ editing
Plug 'wellle/targets.vim'
Plug 'bkad/CamelCaseMotion'
"Plug 'chaoren/vim-wordmotion' " might mess with the boundaries of 'w'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-speeddating'
Plug 'junegunn/vim-easy-align'
Plug 'sirver/ultisnips'
"" }}}

"" {{{ completion
Plug 'ycm-core/YouCompleteMe'
Plug 'Shougo/deoplete.nvim'
Plug 'mattn/emmet-vim'
"" }}}

"" {{{ navigation
Plug 'tpope/vim-unimpaired'
Plug 'easymotion/vim-easymotion'
"" }}}

"" {{{ file navigation
Plug 'tpope/vim-vinegar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
"Plug 'vim-ctrlspace/vim-ctrlspace'
"Plug 'wincent/Command-T'
Plug 'mileszs/ack.vim'
"" }}}

"" {{{ project management
Plug 'tpope/vim-projectionist'
Plug 'vim-syntastic/syntastic'
Plug 'vimwiki/vimwiki'
"Plug 'lervag/wiki.vim'
Plug 'xolox/vim-notes'
"" }}}

"" {{{ external tools
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-fugitive'
Plug 'voldikss/vim-floaterm'
Plug 'voldikss/fzf-floaterm'
"" }}}

"" {{{ file format management
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-sleuth'
"" }}}

"" {{{ file formats
Plug 'tpope/vim-ragtag' " html/xml
Plug 'tpope/vim-jdaddy' " json
Plug 'xolox/vim-lua-ftplugin' " lua
Plug 'rust-lang/rust.vim' " rust
Plug 'kchmck/vim-coffee-script' " coffeescript
Plug 'leafgarland/typescript-vim' " typescript
Plug 'JuliaEditorSupport/julia-vim' " julia
Plug 'cespare/vim-toml' " toml
Plug 'python-mode/python-mode' " python
"" }}}

"" {{{ session management
Plug 'tpope/vim-obsession'
"" }}}

"" {{{ other tools
"Plug 'neoclide/coc.nvim', { 'branch' : 'release' }
"Plug 'Shougo/denite.nvim'
"" }}}

call plug#end()
" }}}

" {{{ mouse
set mouse=a
" }}}

" {{{ directories
set swapfile
set undofile
set backup
set backupdir-=.
if !isdirectory(expand(stdpath('data') . '/backup'))
   call mkdir(expand(stdpath('data') . '/backup'), 'p')
endif
let g:netrw_home=expand(stdpath('data'))
" }}}

" {{{ external programs
let g:powerline_pycmd="py3"

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let g:coc_global_extensions = [ 'coc-tsserver' ]
" }}}

" {{{ appearance
highlight PMenu ctermfg=7* ctermbg=0
" }}}

" {{{ languages

"" {{{ all
setlocal ts=2 sts=2 sw=2 et
"" }}}

"" {{{ filetyped
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 et
autocmd FileType coffee setlocal ts=2 sts=2 sw=2 et makeprg=make
autocmd FileType nim setlocal makeprg=make
autocmd FileType rust setlocal ts=2 sts=2 sw=2 et
autocmd FileType typescript setlocal ts=2 sts=2 sw=2 makeprg=make expandtab formatprg=prettier\ --parser\ typescript
" }}}

" {{{ julia
let g:julia_indent_align_import = 0
let g:julia_indent_align_brackets = 0
let g:julia_indent_align_funcargs = 0
" }}}
" }}}

" {{{ searching
set ignorecase
set smartcase
" }}}

" {{{ syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_c_checkers = []

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:syntastic_quiet_messages = { "!type": "errors" }
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': [] }
" }}}

" {{{ key mapping
"" {{{ which-key config
set timeoutlen=500
let g:which_key_global_map = {}

let g:mapleader = "\<Space>"
nnoremap <silent> <Leader> <Cmd>WhichKey '<Space>'<CR>
"inoremap <silent> <C-i>    <Cmd>WhichKey '<Space>'<CR>
call which_key#register('<Space>', "g:which_key_leader_map")
let g:which_key_leader_map = {}

let g:maplocalleader = ','
nnoremap <silent> <LocalLeader> :<c-u>WhichKey ','<CR>
call which_key#register(',', "g:which_key_local_map")
let g:which_key_local_map = {}
"" }}}

"nnoremap <silent> g :<c-u>WhichKey 'g'<CR>
"call which_key#register('g', "g:which_key_g_map")
"let g:which_key_g_map = {
      "\ 'a': 'get-ascii',
      "\ '8': 'get-hex',
      "\ }

"nnoremap ga ga
"nnoremap g8 g8

"" {{{ categories
let g:which_key_leader_map.b = { 'name': '+buffers' }
let g:which_key_leader_map.s = { 'name': '+search' }
let g:which_key_leader_map.q = { 'name': '+quit' }
let g:which_key_leader_map.t = { 'name': '+text' }
let g:which_key_leader_map.j = { 'name': '+jump' }
let g:which_key_leader_map.n = { 'name': '+numbers' }
"" }}}

"" {{{ windows
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

""" {{{ navigation
nnoremap <silent> <Leader>wk <C-w>k
nnoremap <silent> <Leader>wj <C-w>j
nnoremap <silent> <Leader>wl <C-w>l
nnoremap <silent> <Leader>wh <C-w>h

nnoremap <silent> <Leader>wK <C-w>K
nnoremap <silent> <Leader>wJ <C-w>J
nnoremap <silent> <Leader>wL <C-w>L
nnoremap <silent> <Leader>wH <C-w>H

nnoremap <silent> <Leader>w= <C-w>=

""" }}}
"" }}}

"" {{{ applications
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

""" {{{ generic
""" }}}

""" {{{ vim-floaterm
let g:floaterm_autoclose = 1

nnoremap <silent> <Leader>as <Cmd>FloatermNew<CR>
nnoremap <silent> <Leader>ar <Cmd>FloatermNew ranger<CR>
nnoremap <silent> <Leader>ap <Cmd>FloatermNew python<CR>

nnoremap <silent> <Leader>ag <Cmd>call feedkeys(':Git ')<CR>

nnoremap <silent> <Leader>aft <Cmd>FloatermToggle<CR>
nnoremap <silent> <Leader>afs <Cmd>FloatermNew<CR>
nnoremap <silent> <Leader>afr <Cmd>FloatermNew ranger<CR>
nnoremap <silent> <Leader>afp <Cmd>FloatermNew python<CR>

tnoremap <silent> <C-z> <Cmd>FloatermHide<CR>

nnoremap <silent> <F2> <Cmd>FloatermNew<CR>
tnoremap <silent> <F2> <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <F3> <Cmd>FloatermPrev<CR>
tnoremap <silent> <F3> <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <F4> <Cmd>FloatermNext<CR>
tnoremap <silent> <F4> <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <F5> <Cmd>FloatermToggle<CR>
tnoremap <silent> <F5> <C-\><C-n>:FloatermToggle<CR>
""" }}}

""" {{{ External
autocmd FileType python nnoremap <LocalLeader>= m`:0,$!yapf<CR>``
""" }}}

""" {{{ fzf.vim
let g:fzf_command_prefix = 'Fzf'

nnoremap <silent> <Nop> <Cmd>FzfFiles<CR>
nnoremap <silent> <Nop> <Cmd>FzfGFiles<CR>
nnoremap <silent> <Nop> <Cmd>FzfGFiles?<CR>
nnoremap <silent> <Nop> <Cmd>FzfBuffers<CR>
nnoremap <silent> <Nop> <Cmd>FzfAg<CR>
nnoremap <silent> <Nop> <Cmd>FzfLines<CR>
nnoremap <silent> <Nop> <Cmd>FzfBLines<CR>
nnoremap <silent> <Nop> <Cmd>FzfTags<CR>
nnoremap <silent> <Nop> <Cmd>FzfBTags<CR>
nnoremap <silent> <Nop> <Cmd>FzfMarks<CR>
nnoremap <silent> <Nop> <Cmd>FzfWindows<CR>
nnoremap <silent> <Nop> <Cmd>FzfLocate<CR>
nnoremap <silent> <Nop> <Cmd>FzfHistory<CR>
nnoremap <silent> <Nop> <Cmd>FzfSnippets<CR>
nnoremap <silent> <Nop> <Cmd>FzfCommits<CR>
nnoremap <silent> <Nop> <Cmd>FzfBCommits<CR>
nnoremap <silent> <Leader><Leader> <Cmd>FzfCommands<CR>
nnoremap <silent> <Nop> <Cmd>FzfMaps<CR>
nnoremap <silent> <Nop> <Cmd>FzfHelpTags<CR>

""" }}}
"" }}}

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

""" {{{ generic
nnoremap <silent> <Leader>fs <Cmd>write<CR>
nnoremap <silent> <Leader>fw <Cmd>write<CR>
nnoremap <silent> <Leader>ff <Cmd>Explore<CR>

nnoremap <silent> <Leader>fcr <Cmd>source $MYVIMRC<CR><Cmd>echo 'Sourced' $MYVIMRC<CR>
nnoremap <silent> <Leader>fce <Cmd>edit $MYVIMRC<CR>
""" }}}

""" {{{ sudo
nnoremap <silent> <Leader>fSe <Cmd>SudoEdit<CR>
nnoremap <silent> <Leader>fSs <Cmd>SudoWrite<CR>
nnoremap <silent> <Leader>fSw <Cmd>SudoWrite<CR>
""" }}}
"" }}}

"" {{{ vim-obsession
"" }}}

"" {{{ vim-vinegar
"" }}}

"" {{{ ctrlp.vim
let g:ctrlp_extensions = ['autoignore']
"" }}}

"" {{{ ack.vim
"" }}}

"" {{{ vim-airline
"" }}}

"" {{{ vim-projectionist
"" }}}

"" {{{ vim-apathy
"" }}}

"" {{{ vim-sleuth
"" }}}

"" {{{ vim-ragtag
"" }}}

"" {{{ vim-jdaddy
"" }}}

"" {{{ vim-lua-ftplugin
"" }}}

"" {{{ vim-characterize
"" }}}

"" {{{ vim-which-key
"" }}}

"" {{{ vim-unimpaired
"" }}}

"" {{{ vim-easymotion
"" }}}

"" {{{ targets.vim
"" }}}

"" {{{ CamelCaseMotion
let g:camelcasemotion_key = '<localleader>'
"" }}}

"" {{{ vim-repeat
"" }}}

"" {{{ vim-surround
"" }}}

"" {{{ vim-commentary
"" }}}

"" {{{ vim-abolish
"" }}}

"" {{{ vim-endwise
"" }}}

"" {{{ vim-speeddating
"" }}}

"" {{{ vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"" }}}

"" {{{ deoplete.nvim
"" }}}

"" {{{ emmet-vim
"" }}}

"" {{{ vim-eunuch
"" }}}

"" {{{ vim-tbone
"" }}}

"" {{{ vim-fugitive
"" }}}

"" {{{ fzf-floaterm
"" }}}

"" {{{ coc
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()
"" }}}

" }}}

" {{{ lua
lua require('vimrc')
" }}}


