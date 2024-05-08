if command -v starship &> /dev/null
then
	export STARSHIP_CONFIG=~/.config/starship/lookgood.toml
	eval "$(starship init zsh)"
fi
