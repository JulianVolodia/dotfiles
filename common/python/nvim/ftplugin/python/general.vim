setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab
"
" Wrap at 79 chars for code
setlocal textwidth=79
" Wrap at 72 chars for comments
setlocal formatoptions=cq textwidth=72 foldignore= wildignore+=*.py

" Python2 by default
let g:syntastic_python_checkers = ['flake8']
