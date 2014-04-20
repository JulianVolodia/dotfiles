" TODO:
" - rope integration
" - makegreen
"   (See http://blog.staz.be/?post/2010/09/04/Python-unit-test-and-vim)

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
let g:syntastic_python_checkers = ['flake82']
noremap <localleader>[oS :let g:syntastic_python_checkers = ['flake82']<cr>
noremap <localleader>]oS :let g:syntastic_python_checkers = ['flake8']<cr>
function! s:toggle_syntastic_python_checkers()
	if g:syntastic_python_checkers == ['flake8']
		let g:syntastic_python_checkers = ['flake82']
		echo "flake82"
	else
		let g:syntastic_python_checkers = ['flake8']
		echo "flake8"
	endif
endfunction
noremap <buffer> <silent> <localleader>coS :call <SID>toggle_syntastic_python_checkers()<cr>
