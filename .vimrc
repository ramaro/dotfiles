" Load vim-plug
" XXX Run this first
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'altercation/vim-colors-solarized'
" Plug 'fenetikm/falcon'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
" Plug 'lambdalisue/vim-pyenv'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'google/vim-jsonnet'
Plug 'tpope/vim-rhubarb'
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'nvie/vim-flake8'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-dispatch'
Plug 'szw/vim-tags'

call plug#end()

" Syntax highligting
syn on

" Show whitespace/invisible chars
set list

" 120 char line
set colorcolumn=120
highlight ColorColumn ctermbg=10

" color scheme type
syntax enable
let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" enable vim-workspace's autosave
let g:workspace_autosave_always = 1

" enable vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_autocolors = 0
hi IndentGuidesOdd ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey

" set ctags autogenerate
let g:vim_tags_auto_generate = 1
let g:vim_tags_use_vim_dispatch = 1

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

" enable mouse support
set mouse=a

" map leader key to Space
let mapleader = "\<Space>"

nnoremap <Leader>a :Ack 
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>T :Tags<CR>
nnoremap <Leader>t :terminal<CR>
nnoremap <Leader>h :bp<CR>
nnoremap <Leader>l :bn<CR>
nnoremap <Leader>p :b#<CR>
nnoremap <Leader>r :reg<CR>
nnoremap <Leader>n :set number!<CR>
nnoremap <Leader>m :BookmarkShowAll<CR>
nnoremap <Leader>s :ToggleWorkspace<CR>
nnoremap <Leader>g :IndentGuidesToggle<CR>

" vim-lightline
set laststatus=2

" set j2 files as yaml syntax
au BufRead,BufNewFile *.yaml,*.yml set filetype=yaml
au BufRead,BufNewFile *.j2 set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" setting for .jsonnet and .libjsonnet syntax
au BufRead,BufNewFile *.jsonnet,*.libjsonnet set filetype=jsonnet syntax=jsonnet
autocmd FileType jsonnet setlocal ts=2 sts=2 sw=2 expandtab
