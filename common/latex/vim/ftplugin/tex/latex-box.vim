" Settings {{{
    " Disable default keybindings
    let g:LatexBox_no_mappings = 1
    " Use asynchronous compilation
    let g:LatexBox_latexmk_async = 1
    " Use spaces as wildcards in BibTeX completion
    let g:LatexBox_bibtex_wild_spaces = 1
    " Allow folding
    let g:LatexBox_Folding = 1

    " Use LuaLaTeX as default
    " Enable quickfix error parsing
    " Use -shell-escape for minted
    let g:LatexBox_latexmk_options = "-file-line-error -shell-escape -pdflatex=lualatex"
    " Don't automatically open quickfix window after compilation
    let g:LatexBox_quickfix = 0
    " Don't automatically jump to first error after calling latexmk
    let g:LatexBox_autojump = 0
    " Warning are not errors
    let g:LatexBox_show_warnings = 0

" }}}
" Functions {{{
    " Copied from LaTeX-Box/ftplugin/latex-box/mappings.vim
    function! s:LatexBoxNextSection(type, backwards, visual)
        " Restore visual mode if desired
        if a:visual
            normal! gv
        endif

        " For the [] and ][ commands we move up or down before the search
        if a:type == 1
            if a:backwards
                normal! k
            else
                normal! j
            endif
        endif

        " Define search pattern and do the search while preserving "/
        let save_search = @/
        let flags = 'W'
        if a:backwards
            let flags = 'b' . flags
        endif
        let notcomment = '\%(\%(\\\@<!\%(\\\\\)*\)\@<=%.*\)\@<!'
        let pattern = notcomment . '\v\s*\\(' . join([
                    \ '(sub)*section',
                    \ 'chapter',
                    \ 'part',
                    \ 'appendix',
                    \ '(front|back|main)matter'], '|') . ')>'
        call search(pattern, flags)
        let @/ = save_search

        " For the [] and ][ commands we move down or up after the search
        if a:type == 1
            if a:backwards
                normal! j
            else
                normal! k
            endif
        endif
    endfunction
" }}}
" Mappings {{{
    " Latexmk interface {{{
        " Compile with latexmk in background
        noremap <buffer> <silent> <f5> :Latexmk<cr>
        " Force latexmk compilation
        noremap <buffer> <silent> <f6> :Latexmk!<cr>
        " Show running status for current buffer
        noremap <buffer> <silent> <f7> :LatexmkStatus<cr>
        " View output
        noremap <buffer> <silent> <f8> :LatexView<cr>

    " }}}
    " Movement commands {{{
        " Jump to corresponding match
        nmap <buffer> <silent> % <Plug>LatexBox_JumpToMatch
        vmap <buffer> % <Plug>LatexBox_JumpToMatch
        omap <buffer> % <Plug>LatexBox_JumpToMatch

        " Text object movements
        " Environment
        vmap <buffer> ie <Plug>LatexBox_SelectCurrentEnvInner
        omap <buffer> ie :normal vie<cr>
        vmap <buffer> ae <Plug>LatexBox_SelectCurrentEnvOuter
        omap <buffer> ae :normal vae<cr>
        " Math environment
        vmap <buffer> i$ <Plug>LatexBox_SelectInlineMathInner
        omap <buffer> i$ :normal vi$<cr>
        vmap <buffer> a$ <Plug>LatexBox_SelectInlineMathOuter
        omap <buffer> a$ :normal va$<cr>

        " Jump to sections
        noremap <buffer> <silent> ]] :call <SID>LatexBoxNextSection(0,0,0)<cr>
        noremap <buffer> <silent> ][ :call <SID>LatexBoxNextSection(1,0,0)<cr>
        noremap <buffer> <silent> [] :call <SID>LatexBoxNextSection(1,1,0)<cr>
        noremap <buffer> <silent> [[ :call <SID>LatexBoxNextSection(0,1,0)<cr>
        vnoremap <buffer> <silent> ]] :<c-u>call <SID>LatexBoxNextSection(0,0,1)<cr>
        vnoremap <buffer> <silent> ][ :<c-u>call <SID>LatexBoxNextSection(1,0,1)<cr>
        vnoremap <buffer> <silent> [] :<c-u>call <SID>LatexBoxNextSection(1,1,1)<cr>
        vnoremap <buffer> <silent> [[ :<c-u>call <SID>LatexBoxNextSection(0,1,1)<cr>

    " }}}
    " Wrapping commands {{{
        " These are made similar to those defined in the Surround plugin
        " Change the current environment
        nmap <buffer> <silent> cse <Plug>LatexChangeEnv
        " Wrap selection in a LaTeX command
        xmap <buffer> <silent> sc <Plug>LatexWrapSelection
        " Wrap selection in an environment
        xmap <buffer> <silent> se <Plug>LatexEnvWrapSelection
        " The tagbar plugin is not very useful for larger documents, so its key is
        " remapped to LaTeX-Box's TOC
        noremap <buffer> <silent> <f3> :LatexTOCToggle<cr>

" }}}

" }}}

" vim: foldmethod=marker
