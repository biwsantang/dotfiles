-- init.lua

-- Check if running in VSCode
local is_vscode = vim.g.vscode ~= nil

-- Set leader key early (before plugins load)
vim.g.mapleader = " "  -- Using space as leader key
vim.g.maplocalleader = " "

-- ====================
-- Settings (Active in both environments)
-- ====================

-- Enable syntax highlighting (enabled by default in Neovim)
vim.opt.syntax = 'on'  -- This ensures syntax highlighting is enabled

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

-- Faster hover (reduce delay for CursorHold events)
vim.opt.updatetime = 1000  -- 1 second delay for auto-hover

-- Global LSP floating window borders
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  opts.max_width = opts.max_width or 60
  opts.max_height = opts.max_height or 15
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- ====================
-- Keyboard Layout Management
-- ====================
local keyboard_layout = require('config.keyboard-layout')
keyboard_layout.setup() -- Initialize with Colemak by default

-- Commands for switching keyboard layouts
vim.api.nvim_create_user_command('KeyboardColemak', function()
  keyboard_layout.switch_to_colemak()
end, { desc = 'Switch to Colemak keyboard layout' })

vim.api.nvim_create_user_command('KeyboardQwerty', function()
  keyboard_layout.switch_to_qwerty()
end, { desc = 'Switch to QWERTY keyboard layout' })

vim.api.nvim_create_user_command('KeyboardToggle', function()
  keyboard_layout.toggle_layout()
end, { desc = 'Toggle between Colemak and QWERTY layouts' })

vim.api.nvim_create_user_command('KeyboardStatus', function()
  vim.notify('Current keyboard layout: ' .. keyboard_layout.get_current_layout(), vim.log.levels.INFO)
end, { desc = 'Show current keyboard layout' })

-- Optional: Add keybindings for quick switching
vim.keymap.set('n', '<leader>kc', '<cmd>KeyboardColemak<CR>', { desc = 'Switch to Colemak' })
vim.keymap.set('n', '<leader>kq', '<cmd>KeyboardQwerty<CR>', { desc = 'Switch to QWERTY' })
vim.keymap.set('n', '<leader>kt', '<cmd>KeyboardToggle<CR>', { desc = 'Toggle keyboard layout' })
vim.keymap.set('n', '<leader>ks', '<cmd>KeyboardStatus<CR>', { desc = 'Show keyboard layout' })

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

-- ====================
-- Reload system
-- ====================
require('config.reload')

-- ====================
-- Clipboard integration
-- ====================
require('config.clipboard').setup()
