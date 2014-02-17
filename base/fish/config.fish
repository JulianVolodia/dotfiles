#! /usr/bin/fish

# Some things should be done for all interactive shells
if status --is-interactive
  # Allows to complete aliases as if they were the proper commands
  function alias_with_completion --argument alias command
    alias $alias "$command"
    complete -c $alias -xa "(
    set -l cmd (commandline -pc | sed -e 's/^ *\S\+ *//' );
    complete -C\"$command \$cmd\";
    )"
  end
  # Set up aliases
  source "$XDG_CONFIG_HOME/fish/aliases.fish"
end
