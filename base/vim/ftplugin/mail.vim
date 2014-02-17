" Use this as external file manager
let b:checkattach_filebrowser = 'ranger --choosefiles=%s'

" Use this to add files
noremap <silent> <buffer> <c-a> :AttachFile<cr>
