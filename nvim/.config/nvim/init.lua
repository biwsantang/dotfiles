-- init.lua

-- Check if running in VSCode
local is_vscode = vim.g.vscode ~= nil

-- ====================
-- Settings (Active in both environments)
-- ====================

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Enable true color support
vim.opt.termguicolors = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

-- Search settings
vim.opt.hlsearch = true

-- Show ruler
vim.opt.ruler = true

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
-- Plugin loading
-- ====================
if not is_vscode then
  require('config.lazy')
end
