" vim:fileencoding=utf-8:foldmethod=marker

" {{{ Plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-sensible'

"" libraries
Plug 'tpope/vim-haystack'

"" file management
Plug 'tpope/vim-vinegar'

"" Searching
Plug 'ctrlpvim/ctrlp.vim'
"Plug 'wincent/Command-T'
Plug 'mileszs/ack.vim'

"" interface
Plug 'tpope/vim-flagship'

"" session management
Plug 'tpope/vim-obsession'

"" project management
Plug 'tpope/vim-projectionist'

"" file formats
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-jdaddy'
Plug 'euclidianAce/BetterLua.vim'

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

call plug#end()
" }}}

""" Configuration

set mouse=a

let g:powerline_pycmd="py3"

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"" Lua
lua require('vimrc')
