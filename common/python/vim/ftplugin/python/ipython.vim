" Don't use IPython completion for Python buffers
let g:ipy_completefunc = 'none'

" Don't use default mappings
let g:ipy_perform_mappings = 0
" Starts Vim-IPython integration
noremap <buffer> <localleader>I :IPython<cr>
" Run current line/selected text in IPython, dedent by indentation of first
" line in selection
noremap <silent> <buffer> <localleader>r :python dedent_run_this_line()<cr>
" Run current line/currently selected text in IPython, keep indentation
noremap <silent> <buffer> <localleader>R :python run_this_line()<cr>
" Run entire buffer in IPython
noremap <silent> <buffer> <localleader><return> :python run_this_file()<cr>
" Open Vim-IPython shell
noremap <silent> <buffer> <localleader>s :py if update_subchannel_msgs(force=True): echo("vim-ipython shell updated",'Operator')<cr>
" Toggle sending entire buffer to IPython when saving (default: off)
noremap <silent> <buffer> <localleader>S :call <SID>toggle_send_on_save()<cr>
"map <silent> <buffer> <C-F6> :python send('%pdb')<cr>
"map <silent> <buffer> <F6> :python set_breakpoint()<cr>
"map <silent> <buffer> <s-F6> :python clear_breakpoint()<cr>
"map <silent> <buffer> <F7> :python run_this_file_pdb()<cr>
"map <silent> <buffer> <s-F7> :python clear_all_breaks()<cr>
"" Example of how to quickly clear the current plot with a keystroke
"map <silent> <F12> :python run_command("plt.clf()")<cr>
"" Example of how to quickly close all figures with a keystroke
"map <silent> <F11> :python run_command("plt.close('all')")<cr>
