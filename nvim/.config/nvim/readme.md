# My Neovim Configuration

This is my personal Neovim configuration optimized for Colemak-DH keyboard layout with a rich set of plugins and features.

## Basic Settings

```vim
set termguicolors     " Enable true color support
set number            " Show line numbers
set relativenumber    " Show relative line numbers for easy navigation
set tabstop=2         " Number of spaces for a tab
set shiftwidth=2      " Number of spaces for each indentation level
set autoindent        " Enable auto indentation
set hlsearch          " Highlight search results
set ruler             " Show cursor position
```

## Keyboard Layout Switching

This configuration supports switching between **Colemak-DH** and **QWERTY** keyboard layouts on the fly. This is useful when:
- Connecting from mobile devices (which typically use QWERTY)
- Switching between physical keyboards with different layouts
- Sharing your screen with someone who uses a different layout

### Layout Commands
| Command | Description |
|---------|-------------|
| `:KeyboardQwerty` | Switch to QWERTY layout |
| `:KeyboardColemak` | Switch to Colemak layout |
| `:KeyboardToggle` | Toggle between layouts |
| `:KeyboardStatus` | Show current layout |

### Layout Keybindings
| Key | Action |
|-----|--------|
| `<leader>kq` | Switch to QWERTY |
| `<leader>kc` | Switch to Colemak |
| `<leader>kt` | Toggle layout |
| `<leader>ks` | Show current layout |

## Core Keybindings

### Navigation Keys (Colemak-DH Optimized)
| Key | Action | Original Vim Key |
|-----|--------|-----------------|
| `n` | Move down | `j` |
| `e` | Move up | `k` |
| `i` | Move right | `l` |
| `j` | Jump to end of word | `e` |
| `k` | Find next search match | `n` |
| `l` | Enter insert mode | `i` |

### Change/Delete Operations
| Key | Action |
|-----|--------|
| `cl` | Change inner (remapped from `ci`) |
| `ci` | Change line (remapped from `cl`) |
| `dl` | Delete inner (remapped from `di`) |
| `di` | Delete line (remapped from `dl`) |

**Note:** These remappings are active when using Colemak layout. Switch to QWERTY layout to use standard Vim keybindings.

## Plugin Keymaps

### LSP (Language Server Protocol)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `go` | Go to type definition |
| `gr` | Find references |
| `gs` | Show signature help |
| `<F2>` | Rename symbol |
| `<F3>` | Format code |
| `<F4>` | Code actions |

### Telescope
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |

### Nvim-Tree
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer and focus |
| `<leader>E` | Close file explorer |
| `o` | Open file |
| `O` | Open file (no window picker) |
| `P` | Preview file (watch mode) |

### Window Management
| Key | Action |
|-----|--------|
| `<leader>wn` | Pick window |

### Claude Code
| Key | Action |
|-----|--------|
| `<leader>ac` | Toggle Claude |
| `<leader>af` | Focus Claude |
| `<leader>ar` | Resume Claude |
| `<leader>aC` | Continue Claude |
| `<leader>ab` | Add buffer to Claude |
| `<leader>as` | Send selection to Claude (visual mode) |
| `<leader>aa` | Accept diff changes |
| `<leader>ad` | Deny diff changes |

use `ctrl+\` then `ctrl+n` to enter normal mode in claude code

### Comment.nvim
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc` + motion | Comment region (e.g., `gcap` for paragraph) |
| `gb` + motion | Block comment region |
| `gcO` | Add comment above current line |
| `gco` | Add comment below current line |
| `gcA` | Add comment at end of line |

## Installed Plugins

1. **LSP Support**
   - mason.nvim (LSP package manager)
   - nvim-lspconfig (LSP configuration)
   - nvim-cmp (Autocompletion)

2. **File Navigation**
   - telescope.nvim (Fuzzy finder)
   - nvim-tree.lua (File explorer)
   - nvim-tree-preview (File preview)

3. **Git Integration**
   - diffview.nvim (Git diff viewer)

4. **UI Enhancement**
   - lightline.vim (Status line)
   - nvim-web-devicons (File icons)
   - nvim-window (Window picker)

5. **Theme and Colors**
   - dracula.nvim
   - github-nvim-theme
   - auto-dark-mode.nvim (Auto theme switching)

6. **Markdown Support**
   - render-markdown.nvim

7. **AI Integration**
   - claudecode.nvim (Claude Code integration)

8. **Code Editing**
   - Comment.nvim (Smart code commenting)
   - nvim-ts-context-commentstring (Context-aware comments for embedded languages)

## Features

- **Smart Theme Switching**: Automatically switches between light and dark themes
- **LSP Integration**: Full language server support with auto-completion
- **File Icons**: Enhanced visual file identification
- **Git Integration**: Advanced diff viewing capabilities
- **Markdown Preview**: Built-in markdown rendering
- **Window Management**: Easy window navigation and management
- **VSCode Compatibility**: Special features when running in VSCode

## Profile System

This configuration supports profile-based plugin loading for faster startup times:

### Available Profiles
- **minimal** (2 plugins): Basic setup with colorschemes and lightline
- **dev** (8 plugins): Development setup with LSP, treesitter, commenting, and core tools
- **full** (13 plugins): Complete setup with all plugins enabled

### Usage

**Start with specific profile:**
```bash
NVIM_PROFILE=minimal nvim
NVIM_PROFILE=dev nvim
NVIM_PROFILE=full nvim
```

**Profile commands:**
- `:ProfileInfo` - Show current profile information
- `:ProfileSet <profile>` - Set profile (requires restart)
- `:ProfileRestart <profile>` - Restart with different profile

**Profile keymaps:**
- `<leader>pm` - Restart with minimal profile
- `<leader>pd` - Restart with dev profile
- `<leader>pf` - Restart with full profile
- `<leader>pi` - Show profile info

Default profile is `dev` if no `NVIM_PROFILE` environment variable is set.

## Usage Tips

1. **Basic Navigation**:
   - Use Colemak-DH optimized movement keys
   - Use relative line numbers for quick jumps

2. **Code Navigation**:
   - Use LSP features for smart code navigation
   - Use FZF-Lua for fuzzy finding files and text

3. **File Management**:
   - Use nvim-tree for file exploration
   - Preview files before opening them

4. **Git Workflow**:
   - Use Diffview for clear git diff visualization

5. **Performance**:
   - Use minimal profile for quick edits
   - Use dev profile for regular coding
   - Use full profile when you need all features

Note: Some features are disabled when running in VSCode to prevent conflicts with VSCode's native functionality.
