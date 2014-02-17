" Open file mentioned on the current line
noremap <silent> <buffer> <cr> :Hgstatusedit<cr>
" Diff file on current line
noremap <silent> <buffer> <leader>vd :Hgstatusdiff<cr>
" Diff file on current line vertically
noremap <silent> <buffer> <leader>vvd :Hgstatusvdiff<cr>
" Diffsum for file on current line or in selection
noremap <silent> <buffer> <leader>vD :Hgstatusdiffsum<cr>
" Vertical diffsum for file on current line or in selection
noremap <silent> <buffer> <leader>vvD :Hgstatusvdiffsum<cr>
" Commit file on current line or in selection
noremap <silent> <buffer> <leader>vC :Hgstatuscommit<cr>
" Commit file on current line or in selection in vertical buffer
noremap <silent> <buffer> <leader>vvC :Hgstatusvcommit<cr>
" Close buffer
noremap <silent> <buffer> q :bd!<cr>
