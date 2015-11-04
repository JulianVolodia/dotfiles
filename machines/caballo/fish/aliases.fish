# Laptop-specific aliases
alias b "beet"
alias tr "transmission-remote"

function p --wraps=pacaur
	pacaur $argv
end
function t --wraps=task
	task $argv
end
