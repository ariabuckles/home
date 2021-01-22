" Neovim LSP support
if has('nvim')
  lua require('aria-lsp')

  autocmd FileType typescript set omnifunc=v:lua.vim.lsp.omnifunc

  nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> gc    <cmd>lua vim.lsp.buf.clear_references()<CR>
endif
