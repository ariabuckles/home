" Security disables:
" Modelines have occasional vulnerabilities and we don't use them, so:
set modelines=0
set nomodeline

autocmd!

" Add fzf brew package support:
if executable('fzf')
  set runtimepath+=/usr/local/opt/fzf/
endif

" located in /etc/vimrc from centos
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

" Turn on backups in ~/.Trash:
" https://vim.fandom.com/wiki/Keep_incremental_backups_of_edited_files
set backup
set backupdir=${HOME}/.vimbackups
let datebackups = strftime("%y-%m-%d_%Hh%Mm")
let datebackups = "set backupext=~". datebackups
execute datebackups


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
autocmd FileType coffee setlocal tabstop=2
autocmd FileType html setlocal shiftwidth=2
autocmd FileType html setlocal shiftwidth=2
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

let mapleader=" "

"lnoremap does 'language mode', which applies in all text insert situations,
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
autocmd BufRead *.ts,*.tsx set filetype=javascript

autocmd FileType java setlocal shiftwidth=4
autocmd FileType java setlocal tabstop=4

function! TrimWhiteSpace()
    %s/\s\s*$//e
endfunction

"autocmd BufWritePre *.js,.jsx,*.py :call TrimWhiteSpace()
"autocmd FileWritePre *.js,.jsx,*.py :call TrimWhiteSpace()
"autocmd FileAppendPre *.js,.jsx,*.py :call TrimWhiteSpace()
"autocmd FilterWritePre *.js,.jsx,*.py :call TrimWhiteSpace()

hi clear Search
hi! def Search ctermfg=0 ctermbg=11
autocmd FileType javascript source ${HOME}/.vim/aria/jshighlight.vim

"Okay, time to get crazy and make this more usable.
"Game mode controls. -_-
"Right hand game controls because we apparently use the
"left hand keys....
noremap i k
noremap j h
noremap k j
"restore an insert command (but try to use a more?)
noremap h i
noremap ; a

"Word/paragraph navigation with shift
noremap I {
noremap J b
noremap K }
noremap L w
noremap H I

"Line/page navigation with control
"We rebind C-ijkl in terminal.app to standard ctrl-pbnf:
noremap <C-p> <PageUp>
noremap <C-b> ^
noremap <C-n> <PageDown>
noremap <C-f> $
"Control uses single char navigation while in insert mode:
inoremap <C-p> <Up>
inoremap <C-b> <Left>
inoremap <C-n> <Down>
inoremap <C-f> <Right>

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

"Normal mode: tab navigation!
nnoremap <Tab> <C-w>w
nnoremap <leader><Tab> gt

" Closing files
nnoremap <silent> <leader>q :bdel<CR>
nnoremap <silent> <leader>w :update<CR>:file<CR>

"Line number magicks:
"use hybrid absolute/relative numbers
set number relativenumber

"set line number style based on entering/leaving the buffer:
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"Make Ctrl-C run the line number autocommands above
noremap <C-c> <C-[>
noremap <C-C> <C-[>
inoremap <C-C> <C-[>
inoremap <C-c> <C-[>

"Settings for live coding:
set nonumber norelativenumber
augroup numbertoggle
  autocmd!
augroup END
"set showtabline=2
"set scrolloff=0

"Neovim cursor styling:
set guicursor=n-v-c-sm:block-blinkoff0,i-ci:blinkwait0-blinkoff500-blinkon500,r-cr-o:hor20

" https://stackoverflow.com/questions/1675688/make-vim-show-all-white-spaces-as-a-character
" Show whitespace
set listchars=tab:↦ ,trail:·,extends:»,precedes:«
set list
augroup trailingwhitespace
  autocmd!
  autocmd InsertEnter * set nolist
  autocmd InsertLeave * set list
augroup END

" vim-prettier
let g:prettier#autoformat = 0
if or(filereadable(findfile('prettier.conf.js', '.;')), filereadable(findfile('.prettierrc.js', '.;')))
  autocmd BufWritePre *.js Prettier
endif

" fzf.vim
if executable('fzf')
  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = float2nr(20)
    let width = float2nr(80)
    let horizontal = float2nr((&columns - width) / 2)
    let vertical = float2nr((&lines - height) / 2 - 1)

    let opts = {
          \ 'relative': 'editor',
          \ 'row': vertical,
          \ 'col': horizontal,
          \ 'width': width,
          \ 'height': height,
          \ 'style': 'minimal'
          \ }

    call nvim_open_win(buf, v:true, opts)
  endfunction
  " https://www.reddit.com/r/vim/comments/9ifsjf/vim_fzf_question_about_switching_to_already_open/
  function! s:GotoOrOpen(command, ...)
    for file in a:000
      if a:command == 'e'
        exec 'e ' . file
      else
        exec "tab drop " . file
      endif
    endfor
  endfunction
  command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)
  " Set up fzf to go top-down
  let $FZF_DEFAULT_OPTS='--exact --reverse --tiebreak=length,end --margin=1,4 --color=16'
  " Use <enter> to open result in new tab
  let g:fzf_action = { 'enter': 'GotoOrOpen tab', 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit', 'ctrl-b': 'edit' }
  " When opening, jump to existing buffer if found
  let g:fzf_buffers_jump = 1
  " Put fzf in a floating window:
  if has('nvim')
    let g:fzf_layout = { 'window': 'call FloatingFZF()' }
  endif
  noremap <silent> <leader>o :Files<CR>
  noremap <silent> <leader>f :Windows<CR>
  noremap <silent> <C-o> :Files<CR>
endif

" Colors
highlight Pmenu ctermbg=gray

" coc.nvim:
" From https://github.com/neoclide/coc.nvim
"set hidden
"set cmdheight=2
"set updatetime=300
"set shortmess+=c
"
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

" Enable true color support things once we have a terminal for that?
"if has("nvim")
"  set termguicolors
"endif

" Parity between vim and nvim:
set background=light

" Security disables:
" Modelines have occasional vulnerabilities and we don't use them, so:
set modelines=0
set nomodeline

