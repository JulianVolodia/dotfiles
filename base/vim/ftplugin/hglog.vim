" Run diff between revision on current line and revision prior to it
noremap <silent> <buffer> <cr> :Hglogdiff<cr>
" Open revision for editing in a read-only window
noremap <silent> <buffer> <leader>ve :Hglogrevedit<cr>
" Close buffer
noremap <silent> <buffer> q :bd!<cr>
