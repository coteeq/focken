set nocompatible              " be iMproved, required
filetype off                  " required

" dein init
" {{{
set runtimepath+=/home/syn/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('/home/syn/.cache/dein')
  call dein#begin('/home/syn/.cache/dein')

  call dein#add('/home/syn/.cache/dein/repos/github.com/Shougo/dein.vim')

  call dein#add('itmammoth/doorboy.vim')
  call dein#add('dracula/vim')
  call dein#add('octol/vim-cpp-enhanced-highlight')
  call dein#add('Shougo/defx.nvim')
  call dein#add('Shougo/deoplete.nvim')
"  call dein#add('Shougo/deoplete-clangx')
  call dein#add('junegunn/goyo.vim')
  call dein#add('mkitt/tabline.vim')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable
" }}}

set mouse=a
set number
set ignorecase
set smartcase
set incsearch
set tabstop=4
set shiftwidth=4
set numberwidth=4
set expandtab
set autoindent
set smartindent
set fdm=marker
syntax on
set laststatus=0

nnoremap Q @q

let g:deoplete#enable_at_startup = 0

hi TabLine      ctermbg=0     ctermfg=White  cterm=NONE
hi TabLineFill  ctermbg=0     ctermfg=White  cterm=NONE
hi TabLineSel   ctermbg=8    ctermfg=White  cterm=NONE
hi Folded       ctermbg=Black

"dont reset selection on indent
vnoremap > >gv
vnoremap < <gv

" defx keys
"{{{
nnoremap <C-o> :tabnew<CR>:Defx<CR>
nnoremap <C-t> :tabnew<CR>

autocmd FileType defx call s:defx_my_settings()
	function! s:defx_my_settings() abort
	  " Define mappings
	  nnoremap <silent><buffer><expr> <CR>
	  \ defx#do_action('open')
	  nnoremap <silent><buffer><expr> <Right>
	  \ defx#do_action('open')
	  nnoremap <silent><buffer><expr> E
	  \ defx#do_action('open', 'vsplit')
	  nnoremap <silent><buffer><expr> P
	  \ defx#do_action('open', 'pedit')
	  nnoremap <silent><buffer><expr> C
	  \ defx#do_action('toggle_columns',
	  \                'mark:filename:type:size:time')
	  nnoremap <silent><buffer><expr> d
	  \ defx#do_action('remove')
	  nnoremap <silent><buffer><expr> r
	  \ defx#do_action('rename')
	  nnoremap <silent><buffer><expr> !
	  \ defx#do_action('execute_command')
	  nnoremap <silent><buffer><expr> yy
	  \ defx#do_action('yank_path')
	  nnoremap <silent><buffer><expr> <Left>
	  \ defx#do_action('cd', ['..'])
	  nnoremap <silent><buffer><expr> ~
	  \ defx#do_action('cd')
	  nnoremap <silent><buffer><expr> S
	  \ defx#do_action('toggle_sort', 'Time')
	  nnoremap <silent><buffer><expr> q
	  \ defx#do_action('quit')
	  nnoremap <silent><buffer><expr> <Space>
	  \ defx#do_action('toggle_select') . 'j'
	  nnoremap <silent><buffer><expr> *
	  \ defx#do_action('toggle_select_all')
	  nnoremap <silent><buffer><expr> <C-l>
	  \ defx#do_action('redraw')
	  nnoremap <silent><buffer><expr> <C-g>
	  \ defx#do_action('print')
	  nnoremap <silent><buffer><expr> cd
	  \ defx#do_action('change_vim_cwd')
endfunction
"}}}

