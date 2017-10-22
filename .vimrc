" Load vim-plug
" XXX Run this first
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'lambdalisue/vim-pyenv'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'google/vim-jsonnet'
Plug 'tpope/vim-rhubarb'
Plug 'mileszs/ack.vim'

call plug#end()


" set for for MacVim
set gfn=Monaco:h14

" Syntax highligting
syn on

" 80 char line
set colorcolumn=80

" color scheme type
syntax enable
set background=dark
colorscheme solarized

" show line numbers
set number

" disable old vi bugs and limitations
set nocompatible

" pressing enter, line will match the previous ident
set autoindent

" try to guess smartly the beginning of the new line
set smartindent

" four space tab
set tabstop=4

" shows matching ( { [ ] } )
set showmatch

" allows  '<' '>' to ident and unident in visual mode
set shiftwidth=4

" show line and column number in the bottom
set ruler

" expands tabs as spaces
set expandtab

" set delete as backspace, more powerfull backspace
set backspace=indent,eol,start

" set automatic case match when adding a new bracket or parentisis closing
set smartcase

" set omni complete
filetype plugin on
filetype indent on

" set highlight search
set hlsearch
" highlight when typing
set incsearch

" show options in menu
set wildmenu

" map leader key to Space
let mapleader = "\<Space>"

nnoremap <Leader>a :Ack 
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>h :bp<CR>
nnoremap <Leader>l :bn<CR>
nnoremap <Leader>p :b#<CR>
nnoremap <Leader>r :reg<CR>
nnoremap <Leader>n :set number!<CR>

" vim-lightline
set laststatus=2
