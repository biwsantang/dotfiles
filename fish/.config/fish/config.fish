# Fish configuration - converted from Zsh setup

# Source .fishprofile shell environment variables
source $HOME/.fishprofile

# Environment variables from .zshrc
set -gx PATH $PATH /Users/biwsantang/.cache/lm-studio/bin
set -gx PATH /Users/biwsantang/.bun/bin $PATH
set -gx PATH $PATH /Users/biwsantang/.local/bin

# Editor configuration
set -gx EDITOR "/opt/homebrew/bin/nvim"
set -gx VISUAL "/opt/homebrew/bin/nvim"

# Bat theme
set -gx BAT_THEME "ansi"

# Starship prompt configuration
set -gx STARSHIP_CONFIG ~/.config/starship/lookgood.toml
starship init fish | source

# CodeEdit shell integration
if test "$TERM_PROGRAM" = "CodeEditApp_Terminal"
    source "/Applications/CodeEdit.app/Contents/Resources/codeedit_shell_integration.fish" 2>/dev/null
end

# Forgit plugin (if available)
if test -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.fish
    source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.fish
end

if status is-interactive
    # Aliases (converted from Zsh)
    alias c="clear"
    alias ls="eza"
    alias ll="ls -lahF"
    alias cat="bat"
    alias mkdir="mkdir -p"
    alias cp="cp -r"
    alias cb="cd .."
    alias ch="cd ~"
    alias cc="claude"
    alias ccb="claude --dangerously-skip-permissions"
    # Use floating pane in zellij, regular command otherwise
    function ccc
        if set -q ZELLIJ
            zellij action new-pane --floating --close-on-exit -- claude --dangerously-skip-permissions '/commit'
        else
            claude --dangerously-skip-permissions '/commit'
        end
    end
    
    # SSH with compatible terminal when needed
    alias sshc="TERM=xterm-256color command ssh"
    
    # Claude PR function
    function ccpr
        claude --dangerously-skip-permissions "/pr $argv"
    end
    
    # Install Ghostty terminfo on remote server
    # Usage: install-ghostty-on user@hostname
    function install-ghostty-on
        infocmp -x xterm-ghostty | ssh $argv -- tic -x -
    end

    # Functions (converted from Zsh)

    # History search function
    function hs
        set -l selected (history --max=100 | fzf --tac --no-sort)
        if test -n "$selected"
            commandline -r $selected
            commandline -f repaint
        end
    end

    # Tmux session function
    function t
        set -l session_name
        if test (count $argv) -eq 0
            set session_name "0"
        else
            set session_name "X"
        end
        tmux new-session -A -s $session_name
    end

    # Edit command line function (Zsh equivalent)
    function edit_command_line
        set -l tmpfile (mktemp)
        commandline > $tmpfile
        $EDITOR $tmpfile
        if test -s $tmpfile
            commandline -r (cat $tmpfile)
        end
        rm -f $tmpfile
    end

    # Key bindings
    bind \ce edit_command_line

    # Fish-specific enhancements
    # Disable greeting
    set fish_greeting ""

    # Enable autosuggestions color
    set -g fish_color_autosuggestion 555

    # Enable completion with underline for valid paths
    set -g fish_color_valid_path --underline

    # Check if zellij is available and launch it
    if command -v zellij >/dev/null 2>&1; and not set -q ZELLIJ
				alias	abcd="claude"
        # Launch zellij
        eval (zellij setup --generate-auto-start fish | string collect)
    end
end
