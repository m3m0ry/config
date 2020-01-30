set nocompatible  " be iMproved, required

" Restore cursor position to where it was before
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

" No backup files but a large history and undofiles
set backupdir=~/.vim/backup/,.backup/,/tmp//
set directory=~/./vim/swp/,.swp/,/tmp//
set history=500
set undolevels=1000
set undofile
set undodir=~/.vim/undo/,.undo/,/tmp//
set undoreload=10000

"misc
set autoread
set lazyredraw
set encoding=utf-8
set visualbell
set splitright
set splitbelow

" Enable folding
set foldmethod=indent
set foldlevel=99

" Syntax highlighting'n stuff
filetype plugin indent on
syntax on
colorscheme desert
set background=dark
set cursorline

"Statusline
set laststatus=2
set statusline=%F%m%r%h%w\ [%l,%v][%p%%]
set wildmenu
set wildmode=list:longest,full
set completeopt=menuone,preview
set confirm

"Completion and searching
set path+=**
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap i :let @/ = ""<CR>i

" Visual goodies
set number
set scrolloff=5
set wrap

"Indentation
set autoindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Tweaks for file browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Enable folding with the spacebar
"nnoremap <space> za

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"buffer hanlding
nnoremap <C-T> :e 
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprev<CR>
" nnoremap <C-Tab> :b 

"other key mappings
inoremap jk <Esc>

"Copy to clipboard
vmap "+y :!xclip -f -sel clip<CR>
map "+p :r!xclip -o -sel clip<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
" could work better
cmap w!! w !sudo tee > /dev/null %

"copy'n'paste and mouse stuff
set mouse=a
set pastetoggle=<F2>

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

" Specific Options:
" Python PEP8
au Filetype python setl tabstop=4 softtabstop=4 shiftwidth=4 textwidth=99 expandtab fileformat=unix
" Git commit
autocmd Filetype gitcommit setlocal spell
