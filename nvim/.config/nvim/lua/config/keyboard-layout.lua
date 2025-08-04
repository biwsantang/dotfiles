-- Keyboard layout management for switching between Colemak and QWERTY
local M = {}

-- Store current layout
M.current_layout = "colemak" -- default to colemak

-- Colemak keybindings
local function set_colemak_mappings()
  -- Navigation remappings for Colemak-DH
  vim.keymap.set({'n', 'v'}, 'n', 'j', { noremap = true })
  vim.keymap.set({'n', 'v'}, 'e', 'k', { noremap = true })
  vim.keymap.set({'n', 'v'}, 'i', 'l', { noremap = true })
  vim.keymap.set({'n', 'v'}, 'j', 'e', { noremap = true })
  vim.keymap.set({'n', 'v'}, 'k', 'n', { noremap = true })
  vim.keymap.set({'n', 'v'}, 'l', 'i', { noremap = true })
  
  -- Change/delete operations
  vim.keymap.set({'n', 'v'}, 'cl', 'ci', { noremap = true })
  vim.keymap.set({'n', 'v'}, 'ci', 'cl', { noremap = true })
  vim.keymap.set({'n', 'v'}, 'dl', 'di', { noremap = true })
  vim.keymap.set({'n', 'v'}, 'di', 'dl', { noremap = true })
end

-- Clear Colemak mappings and restore QWERTY defaults
local function set_qwerty_mappings()
  -- Restore default QWERTY mappings
  vim.keymap.del({'n', 'v'}, 'n')
  vim.keymap.del({'n', 'v'}, 'e')
  vim.keymap.del({'n', 'v'}, 'i')
  vim.keymap.del({'n', 'v'}, 'j')
  vim.keymap.del({'n', 'v'}, 'k')
  vim.keymap.del({'n', 'v'}, 'l')
  
  -- Remove change/delete remappings
  vim.keymap.del({'n', 'v'}, 'cl')
  vim.keymap.del({'n', 'v'}, 'ci')
  vim.keymap.del({'n', 'v'}, 'dl')
  vim.keymap.del({'n', 'v'}, 'di')
  
  -- Note: Vim will use its default mappings when these are deleted
end

-- Switch to Colemak layout
function M.switch_to_colemak()
  if M.current_layout == "colemak" then
    vim.notify("Already using Colemak layout", vim.log.levels.INFO)
    return
  end
  
  set_colemak_mappings()
  M.current_layout = "colemak"
  vim.notify("Switched to Colemak layout", vim.log.levels.INFO)
end

-- Switch to QWERTY layout
function M.switch_to_qwerty()
  if M.current_layout == "qwerty" then
    vim.notify("Already using QWERTY layout", vim.log.levels.INFO)
    return
  end
  
  set_qwerty_mappings()
  M.current_layout = "qwerty"
  vim.notify("Switched to QWERTY layout", vim.log.levels.INFO)
end

-- Toggle between layouts
function M.toggle_layout()
  if M.current_layout == "colemak" then
    M.switch_to_qwerty()
  else
    M.switch_to_colemak()
  end
end

-- Get current layout
function M.get_current_layout()
  return M.current_layout
end

-- Initialize with default layout (Colemak)
function M.setup()
  set_colemak_mappings()
end

return M