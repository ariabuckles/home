" Aria's terminal+vim color scheme

" From $VIMRUNTIME/colors/default.vim:
hi clear Normal
" TODO(aria): Enable this to allow background detection
"set background&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let g:colors_name="aria"


" Colours:

" Vim UI:
hi SignColumn ctermbg=none              guibg=none
hi Pmenu      ctermbg=250    ctermfg=16 guibg=#bcbcbc guifg=#000000
hi PmenuSel   ctermbg=254    ctermfg=16 guibg=#e4e4e4 guifg=#000000
hi Search     ctermbg=yellow ctermfg=16 guibg=#ccff33 guifg=#000000

" Decorations (LSP/Neomake):
hi LspDiagnosticsDefaultHint        ctermfg=lightgrey  guifg=#aaaaaa
hi LspDiagnosticsDefaultInformation ctermfg=lightblue  guifg=#66ccff
hi LspDiagnosticsDefaultWarning     ctermfg=darkyellow guifg=#ff9900
hi LspDiagnosticsDefaultError       ctermfg=red        guifg=#ff3399

" Language Tokens:
" See :help syntax for this list:

hi Comment        ctermfg=blue

hi Constant       ctermfg=darkred
hi String         ctermfg=darkred
hi Character      ctermfg=darkred
hi Number         ctermfg=darkred
hi Boolean        ctermfg=darkred
hi Float          ctermfg=darkred

hi Identifier     ctermfg=none
hi Function       ctermfg=none

hi Statement      ctermfg=darkyellow
hi Conditional    ctermfg=darkyellow
hi Repeat         ctermfg=darkyellow
" TODO(aria): reset these to darkyellow, but prevent typescript from linking
" to them erroneously:
hi Label          ctermfg=none
hi Operator       ctermfg=none
hi Keyword        ctermfg=darkyellow
hi Exception      ctermfg=darkyellow

hi PreProc        ctermfg=darkmagenta
hi Include        ctermfg=darkmagenta
hi Define         ctermfg=darkmagenta
hi Macro          ctermfg=darkmagenta
hi PreCondit      ctermfg=darkmagenta

hi Type           ctermfg=darkgreen
hi StorageClass   ctermfg=cyan
hi Structure      ctermfg=darkgreen
hi Typedef        ctermfg=darkgreen

hi Special        ctermfg=darkmagenta
hi SpecialChar    ctermfg=darkmagenta
hi Tag            ctermfg=darkmagenta
hi Delimiter      ctermfg=darkmagenta
hi SpecialComment ctermfg=darkmagenta
hi Debug          ctermfg=darkmagenta

hi Underlined     ctermfg=darkmagenta cterm=underline

hi Ignore         ctermfg=darkgray

hi Error          ctermfg=16 ctermbg=red

hi Todo           ctermfg=16 ctermbg=yellow

