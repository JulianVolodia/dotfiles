function fish_prompt --description "Write out the prompt"
	set -l last_status "$status"
	# Cache some stuff
	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostnamectl --pretty)
	end
	if not set -q __fish_prompt_normal
		set -g __fish_prompt_normal (set_color normal)
	end
	if not set -q __fish_prompt_error
		set -g __fish_prompt_error (set_color $fish_color_error)
	end
	if not set -q __fish_prompt_virtualenv
		set -g __fish_prompt_virtualenv (set_color --bold blue)
	end
	if not set -q __fish_prompt_repo
		set -g __fish_prompt_repo (set_color --bold green)
	end

	set -g __fish_prompt_color "$__fish_prompt_normal"
	switch $USER
		case root
			if not set --q __fish_prompt_cwd
				if set -q fish_color_cwd_root
					set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
				else
					set -g __fish_prompt_cwd (set_color $fish_color_cwd)
				end
			end
			set -g __fish_prompt_symbol '#'

		case '*'
			if not set -q __fish_prompt_cwd
				set -g __fish_prompt_cwd (set_color $fish_color_cwd)
			end
			# Check if we're in an active virtualenv
			if test -e "$VIRTUAL_ENV"
				set -g __fish_prompt_color "$__fish_prompt_virtualenv"
			end
			set -g __fish_prompt_symbol '>'
	end

	if not test $last_status -eq 0
		set -g __fish_prompt_color "$__fish_prompt_error"
	end

	echo -s "$USER" @ "$__fish_prompt_hostname" ' ' (prompt_pwd)
	echo -n -s " $__fish_prompt_color"
	if set -q RANGER_LEVEL
		for _ in (seq (math "$RANGER_LEVEL + 1"))
			echo -n -s "$__fish_prompt_symbol"
		end
	else
		echo -n -s "$__fish_prompt_symbol"
	end
	echo -n -s "$__fish_prompt_normal "
end
