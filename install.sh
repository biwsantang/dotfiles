#!/bin/bash

# Variables
dir=$HOME/.dotfiles                    # dotfiles directory
packages="nvim zsh yabai"           # list of packages to stow
source_line="for file in ~/.config/*.zsh; do source \$file; done"

# Install Homebrew if it's not already installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew could not be found, installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages from Brewfile
if [[ -f "$dir/Brewfile" ]]; then
    echo "Installing packages from Brewfile..."
    brew bundle --file="$dir/Brewfile"
else
    echo "Brewfile not found. Skipping..."
fi

# Install stow
if brew ls --versions stow > /dev/null; then
    echo "Stow is already installed, skipping installation..."
else
    echo "Stow is not installed, installing now..."
    brew install stow
fi

# Change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir

# Stow packages
for package in $packages; do
    stow $package
done
