#! /usr/bin/fish

# Some things should be done for all interactive shells
if status --is-interactive
  # Set up aliases
  source "$XDG_CONFIG_HOME/fish/aliases.fish"
end
