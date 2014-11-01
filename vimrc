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



"no backup files but a large history and undofiles
set history=500
set nobackup
set nowb
set noswapfile
set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000


"misc
set autoread
set noautochdir
set lazyredraw


"syntax highlighting'n stuff
filetype plugin indent on
colorscheme desert
"colorscheme oh-la-la
set background=dark
set cursorcolumn
set cursorline
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
set scrolloff=5
set wrap
" Linebreak on 500 characters
"set lbr
set tw=80

"indentation
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"make <C-q> and <C-s> reach vim
silent !stty -ixon > /dev/null 2>/dev/null


"tabs
nnoremap <C-t> :tabe 
nnoremap <silent> <C-w> :q<CR>
nnoremap <silent> <C-q> :qa<CR>
nnoremap <silent> <C-Left> :tabprevious<CR>
nnoremap <silent> <C-Right> :tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>
nnoremap <silent> <C-l> :tabnext<CR>


"other key mappings
inoremap jj <Esc>
inoremap jk <Esc>
" exit insert all modes with <C-k>
inoremap <C-k> <Esc>
cnoremap <C-k> <Esc>
nnoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
onoremap <C-k> <Esc>


"aliases
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W') ? ('w') : ('W'))
nnoremap <C-d> :q<CR>


"copy'n'paste and mouse stuff
set mouse=a
"set pastetoggle=<F2>vnoremap <C-c> "+y

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
