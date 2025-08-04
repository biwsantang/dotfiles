#/bin/bash

# check if this Ubuntu or macOS
if { [ ! -f /etc/os-release ] || ! grep -q "Ubuntu" /etc/os-release; } && [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script is designed for Ubuntu or macOS. Exiting."
    exit 1
fi

REPO_URL="https://github.com/biwsantang/dotfiles.git"
REPO_BRANCH="ubuntu"
USER_HOME=$(eval echo ~${SUDO_USER:-$USER})
DOTFILES_DIR="$USER_HOME/.dotfiles"

# Check if dotfiles directory exists and is the correct repository
if [ ! -d "$DOTFILES_DIR" ] || [ -z "$(ls -A "$DOTFILES_DIR")" ]; then
    # Ensure git is installed first
    if ! command -v git &> /dev/null; then
        sudo apt update
        sudo apt install -y git || { echo "Failed to install git. Exiting."; exit 1; }
    fi
    
    # Clone the repository
    git clone -b "$REPO_BRANCH" "$REPO_URL" "$DOTFILES_DIR" || { echo "Failed to clone repository. Exiting."; exit 1; }
else
    # Check if the existing directory is the correct repository
    cd "$DOTFILES_DIR" || {
        echo "Error: Could not change to dotfiles directory"
        echo "Please check if the directory exists and you have permissions"
        exit 1
    }
    
    # Verify the remote URL matches the expected repository
    if ! git remote get-url origin | grep -q "$REPO_URL"; then
        echo "Error: $USER_HOME/.dotfiles contains a different repository"
        exit 1
    fi
    
    # Fetch and update the repository
    git fetch origin "$REPO_BRANCH" || { echo "Failed to fetch repository. Exiting."; exit 1; }
    git checkout "$REPO_BRANCH" || { echo "Failed to checkout branch. Exiting."; exit 1; }
    git pull origin "$REPO_BRANCH" || { echo "Failed to pull repository. Exiting."; exit 1; }
fi

# check install apt package if it not already installed

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Install Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install packages from Brewfile
    echo "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/brewfile"
    
    # Install Starship via Homebrew
    if ! command -v starship &> /dev/null; then
        brew install starship || { echo "Failed to install Starship prompt via Homebrew. Exiting."; exit 1; }
    else
        echo "Starship prompt is already installed. Skipping."
    fi
    
    # Install zplug via Homebrew
    if [ ! -d "$USER_HOME/.zplug" ]; then
        brew install zplug || { echo "Failed to install zplug via Homebrew. Exiting."; exit 1; }
    else
        echo "zplug is already installed. Skipping."
    fi
else
    # Check if aptfile exists
    APTFILE="$DOTFILES_DIR/aptfile"
    echo "Checking for aptfile at: $APTFILE"  # Debug statement
    ls -l "$APTFILE"  # Debug statement to list the file details
    if [ ! -f "$APTFILE" ]; then
        echo "Error: aptfile not found in $DOTFILES_DIR"
        exit 1
    fi

    # Download aptfile binary to /tmp
    curl -o /tmp/aptfile https://raw.githubusercontent.com/seatgeek/bash-aptfile/master/bin/aptfile || { echo "Failed to download aptfile. Exiting."; exit 1; }
    chmod +x /tmp/aptfile || { echo "Failed to make aptfile executable. Exiting."; exit 1; }

    # Use aptfile to install packages
    sudo /tmp/aptfile "$APTFILE" || { echo "Failed to install packages using aptfile. Exiting."; exit 1; }
    
    # check if starship is already installed
    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y || { echo "Failed to install Starship prompt. Exiting."; exit 1; }
    else
        echo "Starship prompt is already installed. Skipping."
    fi
    
    # check if zplug is already installed
    if [ ! -d "$USER_HOME/.zplug" ]; then
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh || { echo "Failed to install zplug. Exiting."; exit 1; }
    else
        echo "zplug is already installed. Skipping."
    fi
fi

if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(which zsh)" ]; then
    # Change the default login shell to zsh
    sudo chsh -s "$(which zsh)" "$USER" || { echo "Failed to change default login shell to zsh. Exiting."; exit 1; }
    echo "Changed default login shell to zsh"
else
    echo "Default login shell is already zsh. Skipping."
fi

stow nvim || { echo "Failed to stow nvim. Exiting."; exit 1; }
stow zsh || { echo "Failed to stow zsh. Exiting."; exit 1; }
stow ghostty || { echo "Failed to stow ghostty. Exiting."; exit 1; }
stow claude || { echo "Failed to stow claude. Exiting."; exit 1; }

# disabled code-server config install due to change to use vscode-web instead

#code_extension=(
#     "asvetliakov.vscode-neovim|https://asvetliakov.gallery.vsassets.io/_apis/public/gallery/publisher/asvetliakov/extension/vscode-neovim/1.18.14/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
# )

# if [ -d "$USER_HOME/.local/share/code-server" ]; then
#     for ENTRY in "${code_extension[@]}"; do
#         # Split the entry into name and URL
#         NAME="${ENTRY%%|*}"
#         URL="${ENTRY##*|}"

#         # Check if the extension is already installed
#         if code --list-extensions | grep -r "$NAME"; then
#             echo "Extension '$NAME' is already installed. Skipping..."
#             continue
#         fi

#         # Create a temporary file
#         TEMP_FILE="${mktemp}.vsix"

#         echo "Downloading $URL for extension '$NAME'..."
#         # Download the file
#         curl -L -o "$TEMP_FILE" "$URL"

#         echo "Installing extension '$NAME'..."
#         # Install the extension
#         code --install-extension "$TEMP_FILE"

#         # Clean up the temporary file
#         rm "$TEMP_FILE"

#         echo "Extension '$NAME' installed successfully."
#     done
#     rm "$USER_HOME/.local/share/code-server/User/settings.json"
#     stow vscode -t "$USER_HOME/.local/share/code-server"
# else
#     echo "Not found Code-server. Skiped"
# fi

add_source_if_not_exists() {
    if ! grep -q "$1" $USER_HOME/.zshrc; then
        echo "$1" >> $USER_HOME/.zshrc
    fi
}

source_lines=(
    "source $USER_HOME/.config/zsh/alias.zsh"
    "source $USER_HOME/.config/zsh/rc.zsh"
    "source $USER_HOME/.config/zsh/prompt.zsh"
    "source $USER_HOME/.config/zplug/plugin.zsh"
)

for line in "${source_lines[@]}"; do
    if ! grep -q "$line" $USER_HOME/.zshrc; then
        echo "$line" >> $USER_HOME/.zshrc
    fi
done
