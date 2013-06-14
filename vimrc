" ===================
" ===== General =====
" ===================

"improved by simon
set nocompatible

filetype plugin indent on

": history
set history=200

"modeline (tabwidth, etc)
set modeline

"add x extra lines when going up/down
set scrolloff=10



" =====================
" ===== Look&Feel =====
" =====================

"improved by simon
"display line numbers
set number

"display buffer name
set laststatus=2

"color code
syntax on
colorscheme desert

"display cursor position
set ruler



" =====================
" ===== Searching =====
" =====================

"case insensitive searching, except when using capitals
set smartcase



" =================
" ===== Files =====
" =================

"don't backup anything
"set nobackup

"improved by simon
"keep undo history stored
if isdirectory($HOME . '/.vim/backup') == 0
	call mkdir($HOME . '/.vim/backup', 'p')
endif
set undodir=~/.vim/backups
set undofile

"reload file if changed from the outside
set autoread



" ====================
" ===== Commands =====
" ====================

"alias :W :w
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W') ? ('w') : ('W'))

"not recomended by simon(= [ ] are important omvementes)
"commands for fast switching between buffers
map = :e<Space>
map [ :bp<CR>
map ] :bn<CR>

"write and delete buffer, if only 1 buffer left, quit instead
function Bufclose()
	"  FIXME: wrong, bufnr('$') is not number of buffers, only number of
	"  newest buffer
	let l:bufcnt = bufnr('$')
	if l:bufcnt > 1
		w | bd
	else
		x
	endif
endfunction
map - :call Bufclose()<CR>



" ======================
" ===== Completion =====
" ======================

"no compiled java files
set wildignore=*.class,*.jar

"no compiled c files
set wildignore+=*.o,a.out

"no backup or switch files
set wildignore+=*~,*.swp
