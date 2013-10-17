" don't behave compatible to the old vi
set nocompatible

" restore cursor position to where it was before
augroup JumpCursorOnEdit
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
   " need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END






"no backup files but a large history
set history=500
set nobackup
set nowb
set noswapfile


"misc
set autoread
set noautochdir
set lazyredraw


"syntax highlighting'n stuff
filetype plugin indent on
colorscheme Tomorrow-Night-Blue
syntax on


"statusline
set laststatus=2
set statusline=%F%m%r%h%w\ [%l,%v][%p%%]
set wildmenu
set wildmode=list:longest,full
set completeopt=menuone,preview
set confirm


"completion and searching
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap i :let @/ = ""<CR>i


"visual goodies
set ruler
set number
set showcmd
set scrolloff=7


"indentation
set autoindent
set shiftwidth=4
set softtabstop=4
set noexpandtab


"tabs
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <silent> <C-Left> :tabprevious<CR>
nnoremap <silent> <C-Right> :tabnext<CR>
nnoremap = :tabedit 


"other key mappings
inoremap jj <Esc>
set pastetoggle=<F2>


"aliases
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W') ? ('w') : ('W'))
nnoremap <C-d> :q<CR>


"enable mouse
set mouse=a
