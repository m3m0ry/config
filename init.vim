set nocompatible            " disable compatibility to old-time vi
set path+=**
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
" Enable folding
set foldmethod=indent
set foldlevel=120
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
"set cc=120                 " set an column border for good coding style
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
colorscheme desert
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
" set spell                 " enable spell check (may need to download language package)
set directory=~/./vim/swp/,.swp/,/tmp//
set undoreload=10000
set noswapfile              " disable creating swap file
set backupdir=~/.cache/nvim " Directory to store backup files.
set history=500
set undolevels=1000
set undofile
set undodir=~/.cache/nvim/undo/
set undoreload=10000

"misc
set autoread
set lazyredraw
set encoding=utf-8
set visualbell

" open new split panes to right and below
set splitright
set splitbelow
" move between panes to left/bottom/top/right
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
inoremap jk <Esc>          " press jk to exit insert mode
vnoremap jk <Esc>          " press jk to exit visual mode
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk
" Enable folding with the spacebar
nnoremap <space> za
" buffer hanlding
noremap <C-T> :e 
noremap <Tab> :bnext<CR>
noremap <S-Tab> :bprev<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
" could work better
cmap w!! w !sudo tee > /dev/null %

" Git commit
autocmd Filetype gitcommit setlocal spell
