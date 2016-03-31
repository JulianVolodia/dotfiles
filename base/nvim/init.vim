" vim: set foldmethod=marker:

" Early stuff {{{
	" These have to be put here in order to work, otherwise the plugin keybindings
	" don't pick up the leader change
	let mapleader = "\<space>"
	let maplocalleader = "-"
	" A word on runtimepath settings. {{{
		" Plug adds the rtps of its bundles to the beginning of an existing
		" runtimepath, and its bundle/after rtps at the end of the existing
		" runtimepath. Since Vim gives higher priority to files that are earlier
		" in the runtimepath, this leads to bundle settings having higher
		" precedence than user settings, which just shouldn't happen. In order
		" to alleviate that problem, I wait until after Plug has
		" initialized all its bundles before I set the remaining part of the
		" runtimepath. It should look like this:
		"
		"   u - b - s -- sa - ba - ua
		"
		"   u = User settings (highest priority)
		"   b = Bundle settings (second highest)
		"   s = System settings (lowest priority)
		"   sa = system after/ directories
		"   ba = Bundle after/ directories
		"   ua = User after/ directories
		"
		" This way, user settings take precedence before bundle and system settings,
		" both in the regular plugin/ftplugin directories as well as in the after/
		" directories. I believe this is the way it should be. }}}
	" Early runtimepath dickery!
	set runtimepath=$XDG_CONFIG_HOME/nvim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
	" Plugins {{{
		" Build functions {{{
			" These have to be declared before being referenced in :Plug.
			" Build YCM with correct completer options {{{
				function! BuildYCM(info)
				  " info is a dictionary with 3 fields
				  " - name:   name of the plugin
				  " - status: 'installed', 'updated', or 'unchanged'
				  " - force:  set on PlugInstall! or PlugUpdate!
				  if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
					" Beware: Use a backslash at the beginning of the included line!
					let installer_string = 'normal! !python2 ./install.py '
					!!@@rust-ycm-completer
					execute installer_string
				  endif
				endfunction
			" }}}
		" }}}
		" Plug initialization {{{
			call plug#begin(expand("$XDG_CONFIG_HOME/nvim/bundle"))
			" Bundles
			" Vimproc has a native component
			Plug 'vim-scripts/argtextobj.vim'
			Plug 'bling/vim-bufferline'
			Plug 'tpope/vim-commentary'
			Plug 'vim-scripts/DeleteTrailingWhitespace', { 'on': 'DeleteTrailingWhitespace' }
			Plug 'jeetsukumaran/vim-filebeagle', { 'on': [
				\ 'FileBeagle', 'FileBeagleBufferDir'
				\ ] }
			Plug 'tpope/vim-fugitive'
			Plug 'airblade/vim-gitgutter', { 'on': [
					\ 'GitGutterEnable', 'GitGutterDisable', 'GitGutterToggle',
					\ 'GutGutterSignsEnable', 'GitGutterSignsDisable', 'GitGutterSignsToggle',
					\ 'GitGutterLineHighlightsEnable', 'GitGutterLineHighLightsDisable',
					\ 'GitGutterLineHighlightsToggle',
					\ '<Plug>GitGutterNextHunk', '<Plug>GitGutterPreviousHunk',
					\ '<Plug>GitGutterStageHunk', '<Plug>GitGutterRevertHunk',
					\ '<Plug>GitGutterPreviewHunk'
				\ ] }
			Plug 'michaeljsmith/vim-indent-object'
			Plug 'simnalamburt/vim-mundo', { 'on': [
					\ 'GundoToggle', 'GundoShow', 'GundoHide', 'GundoRenderGraph'
				\ ] }
			Plug 'tpope/vim-obsession', { 'on': 'Obsession' }
			Plug 'tpope/vim-repeat'
			Plug 'tpope/vim-sensible'
			Plug 'altercation/vim-colors-solarized'
			Plug 'tpope/vim-speeddating'
			Plug 'vim-scripts/ShowTrailingWhitespace'
			Plug 'tpope/vim-surround'
			Plug 'SirVer/ultisnips'
			Plug 'tpope/vim-unimpaired'
			Plug 'tpope/vim-dispatch'
			Plug 'Valloric/YouCompleteMe', { 'do':
					\ function('BuildYCM')
				\ }
			!!@@latex-plugin
			!!@@python-plugin
			!!@@rust-plugin
			!!@@as-plugin
			!!@@trabajo-plugin
			" Load last so extensions are properly supported
			Plug 'vim-airline/vim-airline'
			Plug 'vim-airline/vim-airline-themes'

			call plug#end()
			filetype plugin indent on
		" }}}
		" Configuration {{{
			" Airline {{{
				" Use this theme
				let g:airline_theme = 'solarized'
				" Custom symbols dictionary
				if !exists('g:airline_symbols')
					let g:airline_symbols = {}
				endif
				" Separators between categories
				let g:airline_symbols.linenr = '¶'
				let g:airline_symbols.branch = '⎇ '
				let g:airline_symbols.readonly = '₩'
				let g:airline_symbols.paste = 'ρ'
				" Enable modified detection
				let g:airline_detect_modified = 1
				" Enable paste detection
				let g:airline_detect_paste = 1
				" Show a symbol in case of trailing whitespace
				let g:airline#extensions#whitespace#checks = [ 'trailing' ]
				" …but no message
				let g:airline#extensions#whitespace#show_message = 0
				" Define the text to display for each mode
				let g:airline_mode_map = {
					\ 'n'  : 'N',
					\ 'i'  : 'I',
					\ 'R'  : 'R',
					\ 'v'  : 'V',
					\ 'V'  : 'V',
					\ 'c'  : 'C',
					\ '' : 'V',
					\ }

			" }}}
			" Bufferline {{{
				" Don't echo to the command bar
				let g:bufferline_echo = 0
				" Left separator
				let g:bufferline_active_buffer_left = '|'
				" Right separator
				let g:bufferline_active_buffer_right = '|'
				" No numbers, thank you
				let g:bufferline_show_bufnr = 0
				" Rotate list, keep current buffer at same position
				let g:bufferline_rotate = 1
				" Display filename relative to current directory, abbreviate
				" $HOME
				let g:bufferline_fname_mod = ':~:.'
				" Shorten paths in buffer names
				let g:bufferline_pathshorten = 1
				" Don't highlight the buffer if it is alone
				let g:bufferline_solo_highlight = 1
			" }}}
			" DeleteTrailingWhitespace {{{
				" Don't automatically delete on writing a buffer
				let g:DeleteTrailingWhitespace = 0
				" Do this to fix trailing whitespace
				noremap <silent> <leader>k<space> :DeleteTrailingWhitespace<cr>

			" }}}
			" FileBeagle {{{
				" Prefix for opening things in background
				let g:filebeagle_buffer_background_key_map_prefix = '<leader>'
				" Normal mappings
				let g:filebeagle_buffer_normal_key_maps = {
					\ 'FileBeagleBufferRefresh': '<c-r>',
					\ 'FileBeagleBufferToggleHiddenAndIgnored': 'coh',
					\ 'FileBeagleBufferSplitVerticalVisitTarget': '<bar>',
					\ 'FileBeagleBufferBgSplitVerticalVisitTarget': g:filebeagle_buffer_background_key_map_prefix . '<bar>',
					\ 'FileBeagleBufferSplitVisitTarget': '-',
					\ 'FileBeagleBufferBgSplitVisitTarget': g:filebeagle_buffer_background_key_map_prefix . '-',
					\ 'FileBeagleBufferTabVisitTarget': '<tab>',
					\ 'FileBeagleBufferBgTabVisitTarget': g:filebeagle_buffer_background_key_map_prefix . '<tab>',
					\ 'FileBeagleBufferFocusOnParent': 'd',
					\ 'FileBeagleBufferFocusOnPrevious': 'R',
					\ 'FileBeagleBufferInsertTargetBelowCursor': 'p.',
					\ 'FileBeagleBufferBgInsertTargetBelowCursor': g:filebeagle_buffer_background_key_map_prefix . 'p.',
					\ 'FileBeagleBufferInsertTargetAtBeginning': 'p0',
					\ 'FileBeagleBufferBgInsertTargetAtBeginning': g:filebeagle_buffer_background_key_map_prefix . 'p0',
					\ 'FileBeagleBufferInsertTargetAtEnd': 'p$',
					\ 'FileBeagleBufferBgInsertTargetAtEnd': g:filebeagle_buffer_background_key_map_prefix . 'p$',
					\ 'FileBeagleBufferChangeVimWorkingDirectory': 'cd',
					\ 'FileBeagleBufferChangeVimLocalDirectory': 'lcd',
				\ }
				let g:filebeagle_buffer_visual_key_maps = {
					\ 'FileBeagleBufferSplitVerticalVisitTarget': '<bar>',
					\ 'FileBeagleBufferBgSplitVerticalVisitTarget': g:filebeagle_buffer_background_key_map_prefix . '<bar>',
					\ 'FileBeagleBufferSplitVisitTarget': '-',
					\ 'FileBeagleBufferBgSplitVisitTarget': g:filebeagle_buffer_background_key_map_prefix . '-',
					\ 'FileBeagleBufferTabVisitTarget': '<tab>',
					\ 'FileBeagleBufferBgTabVisitTarget': g:filebeagle_buffer_background_key_map_prefix . '<tab>',
					\ 'FileBeagleBufferInsertTargetBelowCursor': 'p.',
					\ 'FileBeagleBufferBgInsertTargetBelowCursor': g:filebeagle_buffer_background_key_map_prefix . 'p.',
					\ 'FileBeagleBufferInsertTargetAtBeginning': 'p0',
					\ 'FileBeagleBufferBgInsertTargetAtBeginning': g:filebeagle_buffer_background_key_map_prefix . 'p0',
					\ 'FileBeagleBufferInsertTargetAtEnd': 'p$',
					\ 'FileBeagleBufferBgInsertTargetAtEnd': g:filebeagle_buffer_background_key_map_prefix . 'p$',
				\ }
			" }}}
			" Fugitive {{{
				" Edit fugitive-revision (with repo basedir as working directory)
				noremap <leader>ge :Gedit<space>
				" Edit fugitive-revision in new tab
				noremap <leader>g<tab> :Gtabedit<space>
				" Read output of git command in new split
				noremap <leader>g- :Gsplit!<space>
				" Read output of git command in vertical split
				noremap <leader>g<bar> :Gvsplit!<space>
				" Read output of git command in preview window
				noremap <leader>gP :Gpedit!<space>
				" Move file and rename buffer accordingly
				noremap <leader>gm :Gmove<space>
				" Move file and rename buffer accordingly (overwrite if necessary)
				noremap <leader>gM :Gmove!<space>
				" Do :w and stage results
				noremap <leader>gw :Gwrite<cr>
				" Do the equivalend of "git checkout %"
				noremap <leader>gr :Gread<cr>
				" Remove current file and delete buffer
				noremap <leader>gR :Gremove<cr>
				" Remove current file and delete buffer forcefully
				noremap <leader>gB :Gblame<cr>
				" Browse on GitHub or on git's own webserver
				noremap <leader>gb :Gbrowse<cr>
				noremap <leader>gs :Gstatus<cr>
				" Show list of revisions for current file in location list
				noremap <leader>gl :Gllog<cr>
				" Show list of commits in location list
				noremap <leader>gL :Gllog --<cr>
				" Open diff window
				noremap <leader>gd :Gdiff<cr>
				noremap <leader>gg :Glgrep<space>
				noremap <leader>gG :Ggrep<space>
				" Open commit buffer (or status buffer if there's nothing staged)
				" -v: Show unified diff in output
				" -q: Don't show help message
				noremap <silent> <leader>gc :Gcommit -v -q<cr>
				noremap <silent> <leader>gps :Gpush<cr>
				noremap <silent> <leader>gpl :Gpull<cr>
			" }}}
			" Git Gutter {{{
				" I'd like to do my own mappings, thanks
				let g:gitgutter_map_keys = 0
				" On, off, toggle
				nnoremap <silent> [ogg :GitGutterEnable<cr>
				nnoremap <silent> ]ogg :GitGutterDisable<cr>
				nnoremap <silent> cogg :GitGutterToggle<cr>
				" On, off, toggle (signs)
				nnoremap <silent> [ogs :GitGutterSignsEnable<cr>
				nnoremap <silent> ]ogs :GitGutterSignsDisable<cr>
				nnoremap <silent> cogs :GitGutterSignsToggle<cr>
				" On, off, toggle (line highlights)
				nnoremap <silent> [ogl :GitGutterLineHighlightsEnable<cr>
				nnoremap <silent> ]ogl :GitGutterLineHighlightsDisable<cr>
				nnoremap <silent> cogl :GitGutterLineHighlightsToggle<cr>
				" Move between hunks
				nmap <silent> [h <Plug>GitGutterPrevHunk
				nmap <silent> ]h <Plug>GitGutterNextHunk
				" Stage a hunk
				nmap <silent> <leader>hs <Plug>GitGutterStageHunk
				" Revert a hunk
				nmap <silent> <leader>hr <Plug>GitGutterRevertHunk
				" Update signs for current buffer
				nnoremap <silent> <leader>gu :GitGutter<cr>
				" Update signs for all buffers
				nnoremap <silent> <leader>gU :GitGutterAll<cr>
			" }}}
			" Mundo {{{
				" Toggles the Gundo windows
				noremap <leader>u :GundoToggle<cr>
				" automatically close Gundo windows on reverting
				let g:gundo_close_on_revert = 1
				" Change mappings for moving around
				let g:gundo_map_move_older = 't'
				let g:gundo_map_move_newer = 'r'

			" }}}
			" Obsession {{{
				" Sets up keybinding, invoked in autocmd below
				" Place for session file depends on whether current file is in Git/Hg repo or
				" not: For repos, session file is $reporoot/.session.vim, for non-repo files,
				" the session file is saved at ./.session.vim
				function! s:obsession() " {{{
					if exists('b:mercurial_dir')
						let dir = fnamemodify(b:mercurial_dir, ':p:h')
					elseif exists('b:git_dir')
						" b:git_dir points to the actual .git directory
						let dir = fnamemodify(b:git_dir, ':p:h:h')
					else
						let dir = fnamemodify(getcwd(), ':p:h')
					endif
					let fname = fnameescape(dir . "/.session.vim")
					execute 'Obsession ' . fname
				endfunction " }}}
				noremap <silent> <leader>o :call <SID>obsession()<cr>
				noremap <silent> <leader>O :Obsession!<cr>
			" }}}
			" ShowTrailingWhitespace {{{
				" Show it by default
				let g:ShowTrailingWhitespace = 0
				" Toggle trailing whitespace display for current buffer
				noremap <silent> co<space> :<c-u>call ShowTrailingWhitespace#Toggle(0)<bar>echo (ShowTrailingWhitespace#IsSet() ? 'Showing trailing whitespace' : 'Not showing trailing whitespace')<cr>

			" }}}
			" Solarized {{{
				set background=dark
				colorscheme solarized
		"	" }}}
			" SpeedDating {{{
				" I'd like to use my own mappings, thanks
				let g:speeddating_no_mappings = 1
				nmap  <C-A>     <Plug>SpeedDatingUp
				nmap  <C-X>     <Plug>SpeedDatingDown
				xmap  <C-A>     <Plug>SpeedDatingUp
				xmap  <C-X>     <Plug>SpeedDatingDown
				nmap k<C-A>     <Plug>SpeedDatingNowUTC
				nmap k<C-X>     <Plug>SpeedDatingNowLocal
			" }}}
			" Surround {{{
				" I'd like to use my own mappings, thanks
				let g:surround_no_mappings = 1
				nmap ks <Plug>Dsurround
				nmap cs <Plug>Csurround
				nmap cS <Plug>CSurround
				nmap ys <Plug>Ysurround
				nmap yS <Plug>YSurround
				nmap yss <Plug>Yssurround
				nmap ySs <Plug>YSsurround
				nmap ySS <Plug>YSsurround
				xmap S <Plug>VSurround
				xmap gS  <Plug>VgSurround
				" I don't use the substitute command in visual/select mode anyways
				xmap s <Plug>VSurround
			" }}}
			" UltiSnips {{{
				" Snippet directory for private snippets
				let g:UltiSnipsSnippetsDir = expand("$XDG_CONFIG_HOME/nvim/snips")
				" All snippets directories, in case I use predefined snippets
				let g:UltiSnipsSnippetDirectories = ["snips", "UltiSnips"]
				" Use this to expand a trigger (i.e. insert a snippet)
				let g:UltiSnipsExpandTrigger = "<c-j>"
				" Use this to jump forward to next trigger
				let g:UltiSnipsJumpForwardTrigger = "<c-j>"
				" Use this to jump backward to next trigger
				let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

			" }}}
			" YouCompleteMe {{{
				" Don't open the location list on :YcmDiags
				let g:ycm_open_loclist_on_ycm_diags = 0
				" Fewer logging messages
				let g:ycm_server_log_level = 'warning'
				" Close preview window after completion
				let g:ycm_autoclose_preview_window_after_completion = 1
				" Interpret relative paths as relative to the current buffer
				" (instead of relative to the current working directory)
				let g:ycm_filepath_completion_use_working_dir = 1
				" Set keybinding for completion
				nnoremap <leader>gt :YcmCompleter GoTo<cr>
				!!@@rust-ycm-config

			" }}}
			!!@@python-plugin-conf
		" }}}

	" }}}
	" Late runtimepath dickery!
	set runtimepath+=$XDG_CONFIG_HOME/nvim/after

" }}}
" General {{{
	!!@@latex-plugin

	" Files {{{
		" Don't create backup files
		set nobackup
		set nowritebackup
		" Persistent undo (see ":help persistent-undo")
		set undofile
		" Common directory for persistent undo files
		set undodir=$XDG_DATA_HOME/nvim/undo

	" }}}
	" Indentation & linebreaks {{{
		" A tab is displayed as 4 spaces
		set tabstop=4
		" Number of spaces to use for each step of (auto)indent
		" A value of 0 uses tabstop
		set shiftwidth=0
		" Use this when pressing <tab> instead of tabstop
		" Allows to keep tabstop at default value while editing as if it's set to
		" softtabstop width
		" Negative value uses shiftwidth
		set softtabstop=-1
		" Don't expand tabs to spaces
		set noexpandtab
		" Insert shiftwidth when pressing Tab at the beginning of a line
		set smarttab
		" Breaks lines in sane places
		set linebreak
		" Indent broken line to previous line to preserve horizontal blocks of
		" text
		set breakindent
	" }}}
	" Search {{{
		" highlight search hits
		set hlsearch
		" Case-insensitive search unless there are capital letters in search expression
		set ignorecase
		set smartcase
		" Use ":s///g" by default
		set gdefault

	" }}}
	" Tabs & buffers {{{
		" Lets you leave edited buffers without having to save them
		set hidden
		" When splitting, only split current viewport
		set noequalalways
		" When splitting, create new viewports below/right to current viewports
		set splitbelow
		set splitright
		" Prettify splits, diffs, folds
		set fillchars="vert: ,fold: ,diff: "
		" Jump to other windows in current tab if they contain the requested buffer
		set switchbuf=useopen

	" }}}
	" Appearance {{{
		" End of line characters
		set listchars=eol:↲,tab:⇄·,trail:␣,extends:⇢,precedes:⇠
		" Add this in front of line if line is too long for terminal
		set showbreak=↪

		" Not necessary because of powerline plugin
		set noshowmode
		" Show tabline only if there is >1 tab
		set showtabline=1

	" }}}
	" Mouse {{{
		" Use mouse
		set mouse=a

	" }}}
	" Completion {{{
		" Show a popup even if there's only one option
		" Show preview window
		" Complete to longest common substring
		set completeopt=menuone,preview,longest
		set wildmode=longest:full,full

	" }}}

" }}}
" Functions {{{
	" Customize  fold text: just fold text with length appended {{{
		function! CustomFoldText()
			"get first non-blank line
			let fs = v:foldstart
			while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
			endwhile
			if fs > v:foldend
				let line = getline(v:foldstart)
			else
				let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
			endif

			let foldSize = 1 + v:foldend - v:foldstart
			let foldSizeStr = " (" . foldSize . " lines)"
			return line . foldSizeStr
		endfunction
		set foldtext=CustomFoldText()

	" }}}
	" Check if I should set up Fugitive keybindings {{{
		function! s:setup_vcs_keybindings()
			if exists('b:keybindings_setup')
				return
			endif
			let b:keybindings_setup = 1

			elseif exists('b:git_dir')
				call s:setup_fugitive_mappings()
			endif
		endfunction

	" }}}

" }}}
" Keybindings {{{
	" Movement {{{
		" Use dtrn for hjkl {{{
			noremap <silent> d h
			noremap <silent> t j
			noremap <silent> r k
			noremap <silent> n l

			" Fix alllll the other mappings…
			" First: <c-h>, <c-m>, <c-l> are the new H, M, L
			noremap <silent> <c-h> H
			noremap <silent> <c-m> M
			noremap <silent> <c-l> L

			" d > k (Mnemonic: "k"ut instead of "d"elete)
			noremap <silent> k d
			noremap <silent> K D
			" do, dp > Do, DP
			noremap Do do
			noremap Dp dp
			" t > j (Mnemonic: "j"ump towards)
			" Also, it's right next to f, which performs a similar function
			noremap <silent> j t
			noremap <silent> J T
			" Fuck it, H is line joining now…
			noremap <silent> H J
			" …and h is line splitting
			noremap <silent> h <esc>i<cr><esc>

			" r > s (Mnemonic: "s"ubstitute)
			noremap <silent> s r
			noremap <silent> S R
			" <c-u> is now redo
			noremap <silent> <c-u> <c-r>

			" n -> l, like in Vimperator: "l"ook
			noremap <silent> l n
			noremap <silent> L N

			" Easier movement between virtual lines
			noremap <silent> t gj
			noremap <silent> r gk
			noremap <silent> gt j
			noremap <silent> gr k

			" Easier movement between viewports
			nnoremap <c-d> <c-w>h
			nnoremap <c-t> <c-w>j
			nnoremap <c-r> <c-w>k
			nnoremap <c-n> <c-w>l

			noremap <c-w>D <c-w>h
			noremap <c-w>T <c-w>j
			noremap <c-w>R <c-w>k
			noremap <c-w>N <c-w>l

		" }}}

		" Use <tab> to teleport to matching parens
		map <tab> %

		" Make arrow keys do something useful, resize viewports
		nnoremap <silent> <left> :vertical resize +2<cr>
		nnoremap <silent> <right> :vertical resize -2<cr>
		nnoremap <silent> <up> :vertical resize -2<cr>
		nnoremap <silent> <down> :vertical resize +2<cr>

	" }}}
	" Command-line window {{{
		" Use Q for macros
		noremap Q q
		" q is often used to close transient windows, so being able to use it without
		" a delay is nice
		" I'll just use <c-f> on the command line to open the :,/, and ? windows
		noremap q <nop>

		" allow leaving cmdline-window with <esc>
		au CmdwinEnter * nnoremap <buffer> <esc> :quit<cr>
		" Select current line without having to enter insert mode
		au CmdwinEnter * nnoremap <buffer> <cr> i<cr>

	" }}}
	" Quickfix and location list windows {{{
		" Use unimpaired for the regularly used bracket commands
		" Re-read error file
		noremap <silent> <leader>cf :cgetfile<cr>
		" Re-read error file and jump to first error
		noremap <silent> <leader>cj :cfile<cr>
		" List all errors
		noremap <silent> <leader>cl :clist<cr>
		" Go to older quickfix error list
		noremap <silent> <leader>c[ :colder<cr>
		" Go to newer quickfix error list
		noremap <silent> <leader>c] :cnewer<cr>

		" NOTE: No location list command changes buffers
		" Re-read error file
		noremap <silent> <leader>lf :lgetfile<cr>
		" Re-read error file and jump to first error
		noremap <silent> <leader>lj :lfile<cr>
		" Go to older error location list
		noremap <silent> <leader>l[ :lolder<cr>
		" Go to newer error location list
		noremap <silent> <leader>l] :lnewer<cr>

	" }}}

	" Easier :nohl
	noremap <silent> <cr> :nohlsearch<cr>
	" Make Y behave like D and C
	noremap <silent> Y y$
	" Make , search forwards and <Shift-,> search backwards
	" noremap , ;
	noremap ; –

" }}}
