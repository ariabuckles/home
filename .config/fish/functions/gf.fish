function gf
	git fetch; and git stash; and git rebase $argv; and git stash pop
end
