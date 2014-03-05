#!/usr/bin/fish
# vim: set foldmethod=marker:

# Slashes are no fun on a German keyboard
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."

alias ls "ls -F -h --color --group-directories-first"
alias la "ls -A"
alias ll "ls -l"
alias lla "ls -la"

alias p "pacaur"
alias t "task"
alias s "systemctl"
alias syu "systemctl --user"
alias j "journalctl"
alias jyu  "journalctl --user"
