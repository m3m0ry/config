set nocompatible              " be iMproved, required
filetype off                  " required for vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('some/path')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" A code-completion engine for Vim http://valloric.github.io/YouCompleteMe/
Plugin 'Valloric/YouCompleteMe'

" Generates config files for YouCompleteMe
Plugin 'rdnetto/YCM-Generator'

" UltiSnips - The ultimate snippet solution for Vim.
Plugin 'SirVer/ultisnips'

" vim-opencl
" Plugin 'petRUShka/vim-opencl'

" colorsheme zenburn
Plugin 'jnurmine/Zenburn'

" vim-julia
Plugin 'JuliaLang/julia-vim'

" Nerdtree
"Plugin 'scrooloose/nerdtree'

" Git-stuff in nerdtree
"Plugin 'Xuyuanp/nerdtree-git-plugin'

" Powerline
" Plugin 'powerline/powerline'

" Syntastic
"Plugin 'scrooloose/syntastic'


" Latex
"Plugin 'lervag/vimtex'


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


"Nerd tree auto if vim only
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

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
set encoding=utf-8
set splitbelow
set splitright

" Enable folding
set foldmethod=indent
set foldlevel=99


"syntax highlighting'n stuff
filetype plugin indent on
"colorscheme torte
colorscheme zenburn

set background=dark
"set cursorcolumn
"set cursorline
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

" Plugin YouCompleteMe
" Don't complete with TAB, use C-N and C-P instead
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
" close preview windows if leaving insert mode
let g:ycm_autoclose_preview_window_after_insertion = 1

" Trigger configuration.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"

" Plugin vim-julia
let g:latex_to_unicode_auto=1
let g:latex_to_unicode_tab=0


" vimtex Plugin
"let g:vimtex_enabled=1
"let g:vimtex_view_general_viewer = 'okular'
"if !exists('g:ycm_semantic_triggers')
"      let g:ycm_semantic_triggers = {}
"        endif
"          let g:ycm_semantic_triggers.tex = [
"                  \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
"                  \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
"                  \ 're!\\hyperref\[[^]]*',
"                  \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
"                  \ 're!\\(include(only)?|input){[^}]*',
"                  \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
"                  \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
"                  \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
"                  \ ]



" Nerd-Tree settings
"let g:NERDTreeIndicatorMapCustom = {
"    \ "Modified"  : "✹",
"    \ "Staged"    : "✚",
"    \ "Untracked" : "✭",
"    \ "Renamed"   : "➜",
"    \ "Unmerged"  : "═",
"    \ "Deleted"   : "✖",
"    \ "Dirty"     : "✗",
"    \ "Clean"     : "✔︎",
"    \ "Unknown"   : "?"
"    \ }

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
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set expandtab

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"make <C-q> and <C-s> reach vim
silent !stty -ixon > /dev/null 2>/dev/null

" Enable folding with the spacebar
nnoremap <space> za

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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



" Python PEP8
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
"au BufNewFile,BufRead *.py
"    \ set tabstop=4
"    \ set softtabstop=4
"    \ set shiftwidth=4
"    \ set textwidth=79
"    \ set expandtab
"    \ set autoindent
"    \ set fileformat=unix


let git_settings = system("git config --get vim.settings")
if strlen(git_settings)
   exe "set" git_settings
endif
