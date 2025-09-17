#!/bin/bash

# check if this Ubuntu or macOS
if { [ ! -f /etc/os-release ] || ! grep -q "Ubuntu" /etc/os-release; } && [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script is designed for Ubuntu or macOS. Exiting."
    exit 1
fi

USER_HOME=$(eval echo ~${SUDO_USER:-$USER})

# Use the directory where this script is located as dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Using dotfiles directory: $DOTFILES_DIR"

# check install apt package if it not already installed

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Install Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Define packages for macOS
    BREW_PACKAGES=(
        "zsh"
        "fish"
        "stow"
        "git"
        "jq"
        "neovim"
        "fzf"
        "eza"
        "tmux"
        "bat"
        "starship"
        "zellij"
        "ripgrep"
        "node"
        "bun"
    )
    
    BREW_CASKS=(
        "ghostty"
    )
    
    # Add neovim tap
    echo "Adding neovim tap..."
    brew tap neovim/neovim 2>/dev/null || true
    
    # Install brew packages
    echo "Installing Homebrew packages..."
    for package in "${BREW_PACKAGES[@]}"; do
        if ! brew list --formula | grep -q "^${package}\$"; then
            echo "Installing $package..."
            brew install "$package" || echo "Warning: Failed to install $package"
        else
            echo "$package is already installed. Skipping."
        fi
    done
    
    # Install casks
    echo "Installing Homebrew casks..."
    for cask in "${BREW_CASKS[@]}"; do
        if ! brew list --cask | grep -q "^${cask}\$"; then
            echo "Installing $cask..."
            brew install --cask "$cask" || echo "Warning: Failed to install $cask"
        else
            echo "$cask is already installed. Skipping."
        fi
    done
    
else
    # Define packages for Ubuntu
    APT_PACKAGES=(
        "zsh"
        "fish"
        "stow"
        "git"
        "jq"
        "neovim"
        "fzf"
        "eza"
        "tmux"
        "bat"
        "ripgrep"
        "curl"
        "wget"
        "nodejs"
        "npm"
    )
    
    # Update apt repositories
    echo "Updating apt repositories..."
    sudo apt-get update || { echo "Failed to update apt repositories. Exiting."; exit 1; }
    
    # Add neovim PPA
    echo "Adding neovim PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable || echo "Warning: Failed to add neovim PPA"
    sudo apt-get update || true
    
    # Install apt packages
    echo "Installing apt packages..."
    for package in "${APT_PACKAGES[@]}"; do
        if ! dpkg -l | grep -q "^ii  $package "; then
            echo "Installing $package..."
            sudo apt-get install -y "$package" || echo "Warning: Failed to install $package"
        else
            echo "$package is already installed. Skipping."
        fi
    done
    
    # Install starship on Ubuntu
    if ! command -v starship &> /dev/null; then
        echo "Installing Starship prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y || { echo "Failed to install Starship prompt. Exiting."; exit 1; }
    else
        echo "Starship prompt is already installed. Skipping."
    fi
    
    # Install zellij on Ubuntu (not available via apt)
    if ! command -v zellij &> /dev/null; then
        echo "Installing zellij..."
        # Download and install zellij binary directly to avoid TTY issues
        ZELLIJ_VERSION="v0.43.1"
        curl -L "https://github.com/zellij-org/zellij/releases/download/$ZELLIJ_VERSION/zellij-x86_64-unknown-linux-musl.tar.gz" -o /tmp/zellij.tar.gz || { echo "Failed to download zellij. Exiting."; exit 1; }
        tar -xzf /tmp/zellij.tar.gz -C /tmp || { echo "Failed to extract zellij. Exiting."; exit 1; }
        sudo mv /tmp/zellij /usr/local/bin/ || { echo "Failed to move zellij to /usr/local/bin. Exiting."; exit 1; }
        rm /tmp/zellij.tar.gz
        echo "zellij installed successfully"
    else
        echo "zellij is already installed. Skipping."
    fi
    
    # Install bun on Ubuntu
    if ! command -v bun &> /dev/null; then
        echo "Installing bun..."
        curl -fsSL https://bun.sh/install | bash || { echo "Failed to install bun. Exiting."; exit 1; }
        export PATH="$HOME/.bun/bin:$PATH"
        echo "bun installation completed, PATH updated"
    else
        echo "bun is already installed. Skipping."
    fi
fi

echo "Checking default shell..."
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(which zsh)" ]; then
    # Change the default login shell to zsh
    sudo chsh -s "$(which zsh)" "$USER" || { echo "Failed to change default login shell to zsh. Exiting."; exit 1; }
    echo "Changed default login shell to zsh"
else
    echo "Default login shell is already zsh. Skipping."
fi
echo "Shell configuration completed."

# Install Claude Code via bun
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    bun install -g @anthropic-ai/claude-code || { echo "Failed to install Claude Code. Exiting."; exit 1; }
else
    echo "Claude Code is already installed. Skipping."
fi

# Change to dotfiles directory for stow operations
echo "Changing to dotfiles directory: $DOTFILES_DIR"
cd "$DOTFILES_DIR" || { echo "Failed to change to dotfiles directory. Exiting."; exit 1; }
echo "Current directory: $(pwd)"

# Stow common terminal configurations
echo "Starting stow operations..."
echo "Stowing nvim..."
stow -v -t $HOME nvim || { echo "Failed to stow nvim. Exiting."; exit 1; }
echo "Stowing zsh..."
stow -v -t $HOME zsh || { echo "Failed to stow zsh. Exiting."; exit 1; }
echo "Stowing zellij..."
stow -v -t $HOME zellij || { echo "Failed to stow zellij. Exiting."; exit 1; }
echo "Stowing fish..."
stow -v -t $HOME fish || { echo "Failed to stow fish. Exiting."; exit 1; }
echo "Stow operations completed."

# Stow macOS-specific GUI applications
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Stowing macOS-specific configurations..."
    stow -v -t $HOME ghostty || { echo "Failed to stow ghostty. Exiting."; exit 1; }
    stow -v -t $HOME claude || { echo "Failed to stow claude. Exiting."; exit 1; }
    echo "macOS configurations stowed successfully."
fi


# Setup zsh configuration sourcing
zsh_config_block="# Source all zsh configuration files
for config in ~/.config/zsh/*.zsh; do
    [ -r \"\$config\" ] && source \"\$config\"
done"

# Check if the zsh config block is already in .zshrc
if ! grep -q "for config in ~/.config/zsh/\*.zsh" "$USER_HOME/.zshrc"; then
    echo "$zsh_config_block" >> "$USER_HOME/.zshrc"
    echo "Added zsh configuration sourcing to .zshrc"
else
    echo "zsh configuration sourcing already exists in .zshrc. Skipping."
fi

echo ""
echo "🎉 Dotfiles installation completed successfully!"
echo "All configurations have been installed and stowed."
echo "Please restart your shell or run 'source ~/.zshrc' to apply changes."
exit 0
