set nocompatible
set showcmd
" ===================
" ===== General =====
" ===================

": history
set history=1000

"modeline (tabwidth, etc)
set modeline


set lbr
set tw=80

"add 7 extra lines when going up/down
set scrolloff=7


" =======================
" ===== Indentation =====
" =======================

"default indentation settings
filetype plugin on
filetype indent on

"tabs are 4 whitespaces
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set smarttab


"keep indentation on empty lines
inoremap <CR> <CR>x<BS>



" =====================
" ===== Look&Feel =====
" =====================

"display line numbers
set number

"display buffer name
set ls=2

set encoding=utf8

"color code
syntax enable
colorscheme desert

"display cursor position
set ruler



" =====================
" ===== Searching =====
" =====================

"case insensitive searching, except when using capitals
set ignorecase
set smartcase

"highlight all search results
set hlsearch



" =================
" ===== Files =====
" =================

"don't backup anything
"set backup
"set wb
"set swapfile

"keep undo history stored
if isdirectory($HOME . '/.vim/backup') == 0
silent !mkdir -p ~/.vim/backups >/dev/null 2>&1
endif
set undodir=~/.vim/backups
set undofile

"reload file if changed from the outside
set autoread



" ====================
" ===== Commands =====
" ====================

":I toggles indentation (for copy/paste)
let s:indentFlag = 1
function s:toggleIndent()
	if s:indentFlag == 1
		set noautoindent nosmartindent
		echo "Indentation off"
	else
		set autoindent smartindent
		echo "Indentation on"
	endif
	let s:indentFlag = 1-s:indentFlag
endfunction
command c-i call s:toggleIndent()



" ===================
" ===== Buffers =====
" ===================

"write and delete buffer, if only 1 buffer left, quit instead
let s:bufcnt = bufnr('$')
function Bufclose()
if s:bufcnt > 1
bd
let s:bufcnt = s:bufcnt-1
else
q
endif
endfunction



" ======================
" ===== Completion =====
" ======================

"Turn on the Wild menu
set wildmenu

"no compiled java files
set wildignore=*.class,*.jar

"no compiled c files
set wildignore+=*.o,a.out

"no backup or switch files
set wildignore+=*~,*.swp

set wildignore*=*.pyc

" Regular expressions
set magic
