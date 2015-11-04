#!/usr/bin/fish
# vim: set foldmethod=marker:

# Slashes are no fun on a German keyboard
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."

function ls --wraps=/usr/bin/ls
	/usr/bin/ls -F -h --color --group-directories-first $argv
end
function la --wraps=ls
	ls -A $argv
end
function ll --wraps=ls
	ls -l $argv
end
function lla --wraps=ls
	ls -la $argv
end

function n --wraps=nvim
	nvim $argv
end
function s --wraps=systemctl
	systemctl $argv
end
function syu --wraps=systemctl
	systemctl --user $argv
end
function j --wraps journalctl
	journalctl $argv
end
function jyu --wraps=journalctl
	journalctl --user $argv
end
