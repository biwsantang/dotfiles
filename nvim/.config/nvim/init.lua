-- init.lua

-- Check if running in VSCode
local is_vscode = vim.g.vscode ~= nil

-- ====================
-- Settings (Active in both environments)
-- ====================

-- Enable syntax highlighting
vim.cmd('syntax on')  -- This enables syntax highlighting for various file types

-- Enable true color support
vim.opt.termguicolors = true  -- This ensures that Neovim uses true colors in the terminal

-- Line numbers
vim.opt.number = true  -- Show absolute line numbers
vim.opt.relativenumber = true  -- Show relative line numbers

-- Indentation settings
vim.opt.tabstop = 2  -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2  -- Number of spaces to use for each step of (auto)indent
vim.opt.autoindent = true  -- Copy indent from current line when starting a new line

-- Search settings
vim.opt.hlsearch = true  -- Highlight all matches of the previous search pattern

-- Show ruler
vim.opt.ruler = true  -- Show the cursor position all the time

-- ====================
-- Core keymaps (Active in both environments)
-- ====================
vim.keymap.set({'n', 'v'}, 'n', 'j', { noremap = true })
vim.keymap.set({'n', 'v'}, 'e', 'k', { noremap = true })
vim.keymap.set({'n', 'v'}, 'i', 'l', { noremap = true })
vim.keymap.set({'n', 'v'}, 'j', 'e', { noremap = true })
vim.keymap.set({'n', 'v'}, 'k', 'n', { noremap = true })
vim.keymap.set({'n', 'v'}, 'l', 'i', { noremap = true })

vim.keymap.set({'n', 'v'}, 'cl', 'ci', { noremap = true })
vim.keymap.set({'n', 'v'}, 'ci', 'cl', { noremap = true })

vim.keymap.set({'n', 'v'}, 'dl', 'di', { noremap = true })
vim.keymap.set({'n', 'v'}, 'di', 'dl', { noremap = true })

-- ====================
-- VSCode-specific keybindings (only active when running in VSCode)
-- ====================
if is_vscode then
  -- Set leader key (if not already set elsewhere)
  -- vim.g.mapleader = " "
  
  -- VSCode specific keybindings can be added here
end

-- ====================
-- Non-VSCode-specific keybindings (only active when not running in VSCode)
-- ====================
if not is_vscode then
  -- Example keymaps
  -- vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })  -- Save file
  -- vim.keymap.set('n', '<Leader>q', ':q<CR>', { noremap = true, silent = true })  -- Quit
  -- vim.keymap.set('n', '<Leader>h', ':nohlsearch<CR>', { noremap = true, silent = true })  -- Clear search highlight
end

-- ====================
-- Plugin loading
-- ====================
require('config.lazy')

-- ====================
-- Profile system
-- ====================
require('config.profile-commands')
