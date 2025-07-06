local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load profile system
local profiles = require("config.profiles")

-- Get enabled plugins for current profile
local enabled_plugins = profiles.get_plugins()

-- Create plugin specs based on current profile
local plugin_specs = {}
for _, plugin_name in ipairs(enabled_plugins) do
  table.insert(plugin_specs, { import = "plugins." .. plugin_name })
end

-- Show current profile info
local profile_info = profiles.get_profile_info()
vim.notify("Loading profile: " .. profile_info.current .. " (" .. profile_info.count .. " plugins)", vim.log.levels.INFO)

require("lazy").setup({
	spec = plugin_specs,
	checker = { enabled = true, notify = false },
})
