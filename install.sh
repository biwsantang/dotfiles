#!/bin/bash

# Function to install Homebrew
install_brew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# Function to install packages from Brewfile
install_packages() {
  brew bundle install
}

# Check if macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Check if Homebrew is installed
  if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    install_brew
  fi
  # Assume Brewfile is in the same directory
  if [ -f "./Brewfile" ]; then
    echo "Installing packages from Brewfile..."
    install_packages
  else
    echo "Brewfile not found in current directory."
  fi
else
  echo "This script is designed to run on macOS only."
fi
