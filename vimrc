" ===================
" ===== General =====
" ===================

"tabs
set autoindent
set smartindent

": history
set history=200

"modeline (tabwidth, etc)
set modeline

"add 7 extra lines when going up/down
set scrolloff=10



" =====================
" ===== Look&Feel =====
" =====================

"display line numbers
set number

"display buffer name
set ls=2

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
set nobackup
set nowb
set noswapfile

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

"alias :W :w
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W') ? ('w') : ('W'))

"commands for fast switching between buffers
map = :e<Space>
map [ :bp<CR>
map ] :bn<CR>

"write and delete buffer, if only 1 buffer left, quit instead
let s:bufcnt = bufnr('$')
function Bufclose()
	if s:bufcnt > 1
		w | bd
		let s:bufcnt = s:bufcnt-1
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
