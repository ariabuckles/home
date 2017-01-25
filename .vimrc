autocmd!

" located in /etc/vimrc
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    "autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

"Custom settings
set nocompatible
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal shiftwidth=4
autocmd FileType make setlocal tabstop=4
autocmd FileType ruby setlocal tabstop=2
autocmd FileType ruby setlocal shiftwidth=2
autocmd FileType haml setlocal tabstop=2
autocmd FileType haml setlocal shiftwidth=2
autocmd FileType coffee setlocal tabstop=2
autocmd FileType coffee setlocal shiftwidth=2
set smartindent
set autoindent
set incsearch
set ignorecase
set smartcase
set scrolloff=2
set wildmode=longest,list
set nowrap
autocmd BufRead *.txt set wrap
filetype plugin on

set viminfo='20,<200,s10,h

"lnoremap does "language mode", which applies in all text insert situations,
"but not normal/visaul/visualblock. Notably, this includes search.
"To enable it, we have to set:
":set iminsert=1
"wellll i couldn't get that to work, so noremap! maps something for insert and
"commandline mode
"Couldn't get that to work either so we're back at inoremap
"See http://stackoverflow.com/questions/25745169/to-get-lnoremap-with-l-to-work
"Set shift-left/right (home end from my terminal bindings) to be home/end
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^
noremap <C-e> $
noremap <C-a> ^

autocmd BufRead *.al set filetype=javascript
autocmd BufRead *.md set filetype=markdown

autocmd FileType java setlocal shiftwidth=4
autocmd FileType java setlocal tabstop=4

function! TrimWhiteSpace()
    %s/\s\s*$//e
endfunction

autocmd BufWritePre *.js,.jsx,*.py :call TrimWhiteSpace()
autocmd FileWritePre *.js,.jsx,*.py :call TrimWhiteSpace()
autocmd FileAppendPre *.js,.jsx,*.py :call TrimWhiteSpace()
autocmd FilterWritePre *.js,.jsx,*.py :call TrimWhiteSpace()

autocmd BufRead examples.jsx highlight Comment ctermfg=8

"Okay, time to get crazy and make this more usable.
"Game mode controls. -_-
"Right hand game controls because we apparently use the
"left hand keys....
noremap i k
noremap j h
noremap k j
"restore an insert command (but try to use a more?)
noremap h i

"Word/paragraph navigation with shift
noremap I {
noremap J b
noremap K }
noremap L e

"Line/page navigation with control
noremap <C-i> <PageUp>
noremap <C-j> ^
noremap <C-k> <PageDown>
noremap <C-l> $
"Keep line/page navigation while in insert mode
inoremap <C-i> <C-o><PageUp>
inoremap <C-j> <C-o>^
inoremap <C-k> <C-o><PageDown>
inoremap <C-l> <C-o>$

"Tab completion
"For some reason this needs to be after our <C-i> remapping >_>
"FROM:
"http://vim.wikia.com/wiki/Autocomplete_with_TAB_when_typing_words
"Use TAB to complete when typing words, else inserts TABs as usual.
"Uses dictionary and source files to find matching words to complete.

"See help completion for source,
"Note: usual completion is on <C-n> but more trouble to press all the time.
"Never type the same word twice and maybe learn a new spellings!
"Use the Linux dictionary when spelling is in doubt.
"Window users can copy the file to their machine.
function! Tab_Or_Complete()
	if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
		return "\<C-N>"
	else
		return "\<Tab>"
	endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

