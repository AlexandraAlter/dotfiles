" vim:fileencoding=utf-8:foldmethod=marker

" {{{ Plugins

if empty(glob(stdpath('data') . '/site/autoload/plug.vim'))
  execute 'silent !curl -fLo' . stdpath('data') . '/site/autoload/plug.vim --create-dirs'
    \ . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-sensible'

"" libraries
Plug 'tpope/vim-haystack'

"" file management
Plug 'tpope/vim-vinegar'

"" searching
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim'
"Plug 'wincent/Command-T'
Plug 'mileszs/ack.vim'

"" interface
Plug 'tpope/vim-flagship'

"" session management
Plug 'tpope/vim-obsession'

"" project management
Plug 'tpope/vim-projectionist'

"" file format management
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-sleuth'

"" file formats
Plug 'tpope/vim-ragtag' " html/xml
Plug 'tpope/vim-jdaddy' " json
Plug 'xolox/vim-lua-ftplugin' " lua

"" information
Plug 'tpope/vim-characterize'
Plug 'liuchengxu/vim-which-key'

"" navigation
Plug 'tpope/vim-unimpaired'

"" editing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-speeddating'
Plug 'junegunn/vim-easy-align'

"" external tools
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-fugitive'
Plug 'voldikss/vim-floaterm'

"" other tools
"Plug 'Shougo/denite.nvim'
"Plug 'voldikss/fzf-floaterm'

"" clipboard fix
Plug '~/dotfiles/nvim/bracketed-paste-plugin'

call plug#end()
" }}}

" {{{ Configuration

set swapfile
set undofile
set backup
set backupdir-=.
if !isdirectory(expand(stdpath('data') . '/backup'))
   call mkdir(expand(stdpath('data') . '/backup'), "p")
endif

" {{{ Which-Key

" }}}

set mouse=a

let g:powerline_pycmd="py3"

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" {{{
" }}}


"" Lua
lua require('vimrc')

" }}}

