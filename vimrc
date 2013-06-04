" ===================
" ===== General =====
" ===================

": history
set history=200

"modeline (tabwidth, etc)
set modeline

"add 7 extra lines when going up/down
set scrolloff=7

"automatically compile java, c or c++ code
let fname = expand("%:r")
function Compile()
	let s:fe = expand("%:e")
	let s:fn = expand("%:r")
	let s:ff = expand("%")
	if s:fe == "java"
		execute '! javac ' . s:ff
	else
		if filereadable("Makefile")
			execute '! make'
		elseif s:fe == "c"
			if filereadable(s:fn . '.h')
				execute '! gcc -o ' . s:fn . ' ' . s:ff . ' ' . s:fn . '.h'
			else
				execute '! gcc -o ' . s:fn . ' ' . s:ff
			endif
		elseif s:fe == "cpp"
			execute '! g++ ' . s:ff 
		endif
	endif
endfunction
imap <F12> <Esc>:w<F12>
nnoremap <F12> :call Compile()<CR><CR>:echo fname . ' compiled'<CR>



" =======================
" ===== Indentation =====
" =======================

"default indentation settings
set autoindent
set smartindent
set cindent

"tabs are 4 whitespaces
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

"keep indentation on empty lines
inoremap <CR> <CR>x<BS>



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
set ignorecase
set smartcase

"highlight all search results
set hlsearch



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
command I call s:toggleIndent() 



" ===================
" ===== Buffers =====
" ===================

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

"open new buffer
command! -complete=file -nargs=1 Edit call s:Bufopen(<f-args>)
function s:Bufopen(myfile)
	execute 'edit ' . a:myfile
	let s:bufcnt = s:bufcnt+1
endfunction

"commands for fast switching between buffers
map = :Edit<Space>
map - :call Bufclose()<CR>
map [ :bp<CR>
map ] :bn<CR>



" ======================
" ===== Completion =====
" ======================

"no compiled java files
set wildignore=*.class,*.jar

"no compiled c files
set wildignore+=*.o,a.out

"no backup or switch files
set wildignore+=*~,*.swp
