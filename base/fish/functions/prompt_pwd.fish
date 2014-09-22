function prompt_pwd --description "Print the current working directory, shortened to fit the prompt"
	# Define those here to establish correct scope
	set -l curdir "$PWD"
	set -l curdir_shortened "$curdir"
	set -l resdir ""
	set -l trailing_delim ''
	# Loop over dir names
	while true
		if test "$curdir" = "$HOME"
			set curdir_shortened '~'
		else if set -q shorten_curdir
				set curdir_shortened (basename "$curdir" | sed 's|\([^.]\).*|\1|')
		else
			set curdir_shortened (basename "$curdir")
		end
		# Check if we're in an active virtualenv
		if test -e "$curdir/.venv" -a -e "$VIRTUAL_ENV"
			set curdir_color "$__fish_prompt_virtualenv"
		end
		# Check if we're in a Mercurial repository
		if test -e "$curdir/.hg"
			# Set color if it's not already set by virtualenv
			if not set -q curdir_color
				set curdir_color "$__fish_prompt_repo"
			end
			set resdir "$curdir_color$curdir_shortened$__fish_prompt_normal☿$__fish_prompt_repo"(cat "$curdir/.hg/branch")"$trailing_delim$resdir"
		# Check if we're in a Git repository
		else if test -e "$curdir/.git"
			if not set -q curdir_color
				set curdir_color "$__fish_prompt_repo"
			end
			set resdir "$curdir_color$curdir_shortened$__fish_prompt_normal±$__fish_prompt_repo"(git rev-parse --abbrev-ref HEAD ^ /dev/null)"$trailing_delim$resdir"
		# No repos/virtualenvs
		else
			set resdir "$__fish_prompt_cwd$curdir_shortened$trailing_delim$resdir"
		end

		# Stop at / or ~
		if test $curdir = '/' -o $curdir = "$HOME"
			break
		else
			set curdir (dirname "$curdir")
			# Add trailing delimiter after first iteration
			set trailing_delim "$__fish_prompt_normal"'/'
			set shorten_curdir true
		end
	end
	echo "$resdir"
end
