set runtimepath^=~/.vim/bundle/ctrlp.vim

source ~/.vim/vundle

execute pathogen#infect()

syntax on
filetype plugin indent on
set background=dark

noremap <F1> :NERDTreeFind<ESC>

set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set noswapfile
set cursorline
set number

autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2

let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store$', '\.vim$']

cnoremap sudow w !sudo tee % >/dev/null

set clipboard=unnamed
