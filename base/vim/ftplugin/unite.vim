" Play nice with supertab
let b:SuperTabDisabled = 1
" Enable navigation with control-j and control-k in insert mode
" Remember: no ?noremap with <Plug> mappings
imap <buffer> <silent> <c-j>   <Plug>(unite_select_next_line)
imap <buffer> <silent> <c-k>   <Plug>(unite_select_previous_line)
" Use <esc> to get out of the current unite window
map <buffer> <silent> <esc> <Plug>(unite_exit)
