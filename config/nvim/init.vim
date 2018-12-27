set nocompatible              " be iMproved, required
filetype off                  " required

" Required:
set runtimepath+=/home/syn/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/syn/.cache/dein')
  call dein#begin('/home/syn/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/syn/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  call dein#add('itmammoth/doorboy.vim')
  call dein#add('dracula/vim')
  call dein#add('octol/vim-cpp-enhanced-highlight')
  call dein#add('Shougo/defx.nvim')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/deoplete-clangx')
  call dein#add('mcchrish/nnn.vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

"End dein Scripts-------------------------

set mouse=a
set number
""set cursorline
set ignorecase
set incsearch
set tabstop=4
set shiftwidth=4
set numberwidth=4
set expandtab
set autoindent
set smartindent
set fdm=marker
syntax on
""set noshowmode
set laststatus=0

let g:deoplete#enable_at_startup = 1

