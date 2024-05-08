if command -v starship &> /dev/null
	export STARSHIP_CONFIG=~/.config/starship/lookgood.toml
	eval "$(starship init zsh)"
fi
