set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

""Plugin 'vim-airline/vim-airline'
""Plugin 'vim-airline/vim-airline-themes'
""Plugin 'jordwalke/flatlandia'
Plugin 'scrooloose/nerdtree'
""Plugin 'townk/vim-autoclose'
Plugin 'itmammoth/doorboy.vim'
Plugin 'rafi/awesome-vim-colorschemes'
""Plugin 'flazz/vim-colorschemes'
""Plugin 'KeitaNakamura/neodark.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
""Plugin 'ajh17/Spacegray.vim'
""Plugin 'joshdick/onedark.vim'
Plugin 'dracula/vim'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

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
syntax on
""set noshowmode


"set termguicolors
color dracula
"source /home/syn/.config/nvim/onedark.vim
"color deep-space


set laststatus=0
let NERDTreeShowHidden = 1

