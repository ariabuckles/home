" Neomake Configuration:
call neomake#configure#automake('w')
function FormatAndLint()
  Prettier
  Neomake
endfunction
nnoremap <leader>p :call FormatAndLint()<CR>

autocmd TextChanged * :NeomakeClean
autocmd InsertLeave * :if &modified | NeomakeClean | endif
