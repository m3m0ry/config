set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


" A vim plugin to display the indention levels with thin vertical lines
Plugin 'Yggdroot/indentLine'

" A code-completion engine for Vim http://valloric.github.io/YouCompleteMe/
Plugin 'Valloric/YouCompleteMe'

" Generates config files for YouCompleteMe
Plugin 'rdnetto/YCM-Generator'

call vundle#end()
filetype plugin indent on
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


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

autocmd Filetype gitcommit setlocal spell textwidth=72


"no backup files but a large history and undofiles
set history=500
set nobackup
set nowb
set noswapfile
set undolevels=1000

if version >= 703
	set undofile
	set undodir=~/.vim/undo
	set undoreload=10000
endif

"misc
set autoread
set noautochdir
set lazyredraw


"syntax highlighting'n stuff
filetype plugin indent on
colorscheme torte
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

" Don't complete with TAB, use C-N and C-P instead
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
" close preview windows if leaving insert mode
let g:ycm_autoclose_preview_window_after_insertion = 1


"visual goodies
set ruler
set number
set showcmd
set scrolloff=5
set wrap
" Linebreak on 500 characters
"set lbr
"set tw=80

"Indentation
set autoindent
set tabstop=3
set shiftwidth=3
set softtabstop=3
set expandtab

" Plugin Yggdroot/indentLine
" Vim
let g:indentLine_color_term = 31

" "GVim
let g:indentLine_color_gui = '#A4E57E'

" " none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)

let g:indentLine_char = '┊'
let g:indentLine_enabled = 1
let g:indentLine_leadingSpaceEnabled = 1


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



" what is this?
nnoremap <silent> <BS> :pop<CR>



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
