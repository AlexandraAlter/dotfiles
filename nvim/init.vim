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
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-speeddating'
Plug 'junegunn/vim-easy-align'
"" }}}

"" {{{ completion
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
Plug 'junegunn/fzf.vim'
"Plug 'vim-ctrlspace/vim-ctrlspace'
"Plug 'wincent/Command-T'
Plug 'mileszs/ack.vim'
"" }}}

"" {{{ project management
Plug 'tpope/vim-projectionist'
"" }}}

"" {{{ external tools
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-fugitive'
Plug 'voldikss/vim-floaterm'
"" }}}

"" {{{ file format management
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-sleuth'
"" }}}

"" {{{ file formats
Plug 'tpope/vim-ragtag' " html/xml
Plug 'tpope/vim-jdaddy' " json
Plug 'xolox/vim-lua-ftplugin' " lua
"" }}}

"" {{{ session management
Plug 'tpope/vim-obsession'
"" }}}

"" {{{ other tools
"Plug 'Shougo/denite.nvim'
"Plug 'voldikss/fzf-floaterm'
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
" }}}

" {{{ appearance
"autocmd FileType which_key highlight WhichKeyFloating ctermbg=120 ctermfg=7
" }}}

" {{{ key mapping
let g:which_key_global_map = {}

let g:mapleader = "\<Space>"
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
call which_key#register('<Space>', "g:which_key_leader_map")
let g:which_key_leader_map = {}

let g:maplocalleader = ','
nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>
call which_key#register(',', "g:which_key_local_map")
let g:which_key_local_map = {}

"nnoremap <silent> g :<c-u>WhichKey 'g'<CR>
"call which_key#register('g', "g:which_key_g_map")
"let g:which_key_g_map = {
      "\ 'a': 'get-ascii',
      "\ '8': 'get-hex',
      "\ }

"nnoremap ga ga
"nnoremap g8 g8



"" {{{ vim-obsession
"" }}}

"" {{{ vim-vinegar
"" }}}

"" {{{ ctrlp.vim
"" }}}

"" {{{ fzf.vim
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
"xmap ga <Plug>(EasyAlign)
"nmap ga <Plug>(EasyAlign)
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

"" {{{ vim-floaterm
"" }}}

" }}}

" {{{ lua
lua require('vimrc')
" }}}


