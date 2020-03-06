" Compatibility:

" defaults.vim:
if has('nvim')
  " Recreate defaults.vim
  map Q gq
  inoremap <C-U> <C-G>u<C-U>
  set mouse=a
  " open files to the last cursor position
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
elseif filereadable(expand("$VIMRUNTIME/defaults.vim"))
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
else
  set nocompatible
  echo "Error: no defaults.vim or neovim found"
endif

" Security:

" Turn off modelines and other potential vulnerabilities
source ${HOME}/.vim/after/plugin/security.vim


" Initialization:

if executable('fzf') " Add fzf brew package support:
  set runtimepath+=/usr/local/opt/fzf/
endif

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$" " file encoding
  set fileencodings=utf-8,latin1 " detect file encodings
  setglobal fileencoding=utf-8   " new file encoding
endif


" Baseline Config:

" Disable mouse because it conflicts with the scrolling and copy-pasting I'm
" used to:
set mouse=""

" https://neovim.io/doc/user/options.html#'shada'
set viminfo=!,'50,<200,s100,h
if !has('nvim')
  set viminfofile=${HOME}/.local/.viminfo
endif
" Parity between vim and nvim:
set background=light

" Indentation
set autoindent
set smartindent

" Searching
set hlsearch
set ignorecase
set smartcase

" Hot-reloading
" Vim only checks for updates when running :checktime, saving, or shell
" commands: https://github.com/neovim/neovim/issues/1936
" This checks for update when tabbing back to vim
" note: may only work in neovim/gvim
set autoread
autocmd FocusGained * :checktime

" Redraw the screen when re-focusing
" Because I accidentally Cmd-K too much
" note: may only work in neovim/gvim
autocmd FocusGained * :mode

" Integrate with the system clipboard for default copy/paste ops:
if has('nvim')
  set clipboard=unnamedplus
endif


" Backups:

" Turn on backups in ~/.Trash:
" https://vim.fandom.com/wiki/Keep_incremental_backups_of_edited_files
silent !mkdir -p ${HOME}/.local/vim-backups
set backup
set backupdir=${HOME}/.local/vim-backups
" TODO(aria): mkdir -p ~/.local/vim-backups
let datebackups = strftime("%y-%m-%d_%Hh%Mm")
let datebackups = "set backupext=~" . datebackups
execute datebackups
autocmd BufNewFile,BufRead,BufWritePre * execute datebackups


" Custom Settings:

set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set scrolloff=2
set wildmode=longest,list
set nowrap


" Filetype Settings:
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal shiftwidth=4
autocmd FileType make setlocal tabstop=4
autocmd FileType ruby setlocal tabstop=2
autocmd FileType ruby setlocal shiftwidth=2
autocmd FileType haml setlocal tabstop=2
autocmd FileType haml setlocal shiftwidth=2
autocmd FileType coffee setlocal tabstop=2
autocmd FileType coffee setlocal shiftwidth=2
autocmd FileType html setlocal tabstop=2
autocmd FileType html setlocal shiftwidth=2
autocmd FileType java setlocal shiftwidth=4
autocmd FileType java setlocal tabstop=4
autocmd FileType text set wrap

autocmd BufRead,BufNewFile *.al setfiletype javascript

" Keybinds:

" Set <leader> to <space>, and <space> alone to do nothing
let mapleader=" "
nnoremap <leader> <Nop>

"lnoremap does 'language mode', which applies in all text insert situations,
"but not normal/visual/visualblock. Notably, this includes search.
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

"Okay, time to get crazy and make this more usable.
"Game mode controls. -_-
"Right hand game controls because we apparently use the
"left hand keys....
noremap i k
noremap j h
noremap k j
"restore an insert command (but try to use a more?)
noremap h i
" Map z commands to new movement keys
noremap zi zk
noremap zj zh
noremap zk zj
noremap zh zi

"Word/paragraph navigation with shift
noremap I {
noremap J b
noremap K }
noremap L w
noremap H I

"Tab navigation with <space>j/l
nnoremap <leader>j gT
nnoremap <leader>l gt

"Line/page navigation with control
"We rebind C-ijkl in terminal.app to standard ctrl-pbnf:
noremap <C-p> 20<Up>zz
noremap <C-b> 0^
noremap <C-n> 20<Down>zz
noremap <C-f> $
"Control uses single char navigation while in insert mode:
inoremap <C-p> <Up>
inoremap <C-b> <Left>
inoremap <C-n> <Down>
inoremap <C-f> <Right>

" Swap c and s
"nnoremap c s
"nnoremap s c
"nnoremap ss cl

" Better visual mode <-> visual line mode switching:
" https://vi.stackexchange.com/questions/21427/different-mapping-behavior-for-the-different-visual-modes
" Remap vv to V:
xnoremap <expr> v { 'v': "V", 'V': "v", '<c-v>': "v" }[mode()]

" Make Y behave like D
nnoremap Y y$

" Prevent de-select when indenting blocks
xnoremap < <gv
xnoremap > >gv

" Better `g` commands:
nnoremap gf <C-w>gF

" Search
nnoremap <C-/> :Rg
nnoremap <F8> :Rg<CR>
nnoremap g# g*
nnoremap g* :Rg<CR>

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
inoremap <silent> <Tab> <C-R>=Tab_Or_Complete()<CR>

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
nnoremap <C-q> <C-c>

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
set listchars=tab:↦ ,trail:·,nbsp:_,extends:»,precedes:«
set list
augroup trailingwhitespace
  autocmd!
  autocmd InsertEnter * set nolist
  autocmd InsertLeave * set list
augroup END

" statusline progressive definition
set laststatus=2 " show the status line all the time
" Define a custom statusline
highlight default AriaStatus ctermfg=black ctermbg=darkgray
highlight default AriaStatusFile ctermfg=black ctermbg=lightgray
highlight default AriaStatusInfo ctermfg=white ctermbg=darkgray
set statusline=""
set statusline+=%#AriaStatusFile#\ %f\ %h%w%m%r
set statusline+=%#AriaStatusInfo#\ [%{&filetype}]
set statusline+=%#AriaStatus#%=
set statusline+=%#AriaStatusInfo#%-14.(%l:%c%)
set statusline+=%5.(%p%%\ %)
" But use lightline if available:
set noshowmode
let g:lightline = {
\    'colorscheme': 'Tomorrow_Night_Bright',
\    'tabline_separator': { 'left': '', 'right': '' },
\    'tabline_subseparator': { 'left': '', 'right': '' },
\ }


" Signcolumn:
set signcolumn=yes
highlight SignColumn ctermbg=none


" Linting And Formatting:
" vim-prettier
let g:prettier#autoformat = 0
if or(or(filereadable(findfile('prettier.config.js', '.;')), filereadable(findfile('.prettierrc.js', '.;'))), filereadable(findfile('.prettierrc', '.;')))
  autocmd BufWritePre *.js,*.vue,*.css,*.scss,*.ts,*.tsx Prettier
endif


" Colors
hi clear Search
hi! def Search ctermfg=0 ctermbg=11
highlight Pmenu ctermbg=gray


" :terminal support
set hidden
if has('nvim')
  autocmd TermOpen * startinsert
  tnoremap <C-x> <C-\><C-n>$
endif

" Re-split window size on Cmd+/-
autocmd VimResized * wincmd =

" Print file name on tab to buffer
autocmd BufEnter * file

" Disabled Or Not Sure What These Are:
" In text files, always limit the width of text to 78 characters
"autocmd BufRead *.txt set tw=78

" coc.nvim:
" From https://github.com/neoclide/coc.nvim
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

" TODO(aria): what is this from and why keep it?
"if &term=="xterm"
"     set t_Co=8
"     set t_Sb=[4%dm
"     set t_Sf=[3%dm
"endif

"function! TrimWhiteSpace()
"    %s/\s\s*$//e
"endfunction

"autocmd BufWritePre *.js,.jsx,*.py :call TrimWhiteSpace()
"
"autocmd FileWritePre *.js,.jsx,*.py :call TrimWhiteSpace()
"autocmd FileAppendPre *.js,.jsx,*.py :call TrimWhiteSpace()
"autocmd FilterWritePre *.js,.jsx,*.py :call TrimWhiteSpace()


