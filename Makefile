init:
	curl git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
	fish -c "fisher add jorgebucaran/fishtape"
	fish -c "fisher add jorgebucaran/fish-getopts"

test:
	fish -c "fishtape tests/*.fish"
