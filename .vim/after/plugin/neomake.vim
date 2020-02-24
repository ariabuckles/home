" Neomake Configuration:
" Custom Vue Config without eslint-plugin-html
let vuemaker = neomake#makers#ft#javascript#eslint()
call extend(get(vuemaker, 'args', []), ['--plugin', 'vue'])
let g:neomake_vue_eslint_maker = vuemaker

call neomake#configure#automake('w')
function FormatAndLint()
  Prettier
  Neomake
endfunction
nnoremap <leader>p :call FormatAndLint()<CR>

autocmd TextChanged * :NeomakeClean
autocmd InsertLeave * :if &modified | NeomakeClean | endif
