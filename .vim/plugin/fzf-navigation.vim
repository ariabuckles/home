" FZF Navigation:

" Add <leader-o> <leader-f> fzf window shortcuts
if executable('fzf')
  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = float2nr(20)
    let width = float2nr(120)
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
  let $FZF_DEFAULT_OPTS="--exact --reverse --tiebreak=length,end --margin=1,4 --color=16 --preview='bat --style=changes --color=always {}'"
  " Use <enter> to open result in new tab
  let g:fzf_action = { 'enter': 'GotoOrOpen tab', 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit', 'ctrl-e': 'edit' }
  " When opening, jump to existing buffer if found
  let g:fzf_buffers_jump = 1
  " Put fzf in a floating window:
  if has('nvim')
    let g:fzf_layout = { 'window': 'call FloatingFZF()' }
  endif

  " shortcuts:
  noremap <silent> <leader>o :Files<CR>
  noremap <silent> <leader>f :Windows<CR>
endif
