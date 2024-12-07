#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install stow

brew install git \
    starship \
    jq \
    neovim \
    fzf \
    eza \
    tmux \
    forgit

stow nvim
stow zsh

echo "source ~/.config/zsh/alias.sh" >> ~/.zshrc
echo "source ~/.config/zsh/rc.sh" >> ~/.zshrc

echo "source ~/.config/starship/prompt.sh" >> ~/.zshrc