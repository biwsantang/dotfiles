local M = {}

-- Cache for loaded modules
local loaded_modules = {}

-- Function to unload a Lua module
local function unload_module(module)
  package.loaded[module] = nil
  _G[module] = nil
end

-- Function to reload a specific module
function M.reload_module(module)
  unload_module(module)
  local ok, result = pcall(require, module)
  if ok then
    vim.notify("Reloaded: " .. module, vim.log.levels.INFO)
    return result
  else
    vim.notify("Failed to reload: " .. module .. "\n" .. result, vim.log.levels.ERROR)
    return nil
  end
end

-- Function to reload all Neovim configuration
function M.reload_config()
  -- Clear all lua module cache for our config
  for module, _ in pairs(package.loaded) do
    if module:match("^config") or module:match("^plugins") then
      unload_module(module)
    end
  end
  
  -- Reload the main configuration
  dofile(vim.env.MYVIMRC)
  
  -- Automatically run Lazy sync to handle plugin changes
  vim.defer_fn(function()
    vim.cmd("Lazy sync")
  end, 100)
  
  vim.notify("Configuration reloaded! Running Lazy sync...", vim.log.levels.INFO)
end

-- Function to reload current file's module
function M.reload_current_file()
  local current_file = vim.fn.expand("%:p")
  local config_path = vim.fn.stdpath("config")
  
  -- Check if current file is in config directory
  if not current_file:match("^" .. vim.pesc(config_path)) then
    vim.notify("Current file is not in config directory", vim.log.levels.WARN)
    return
  end
  
  -- Convert file path to module name
  local module = current_file:gsub(vim.pesc(config_path) .. "/lua/", "")
  module = module:gsub("%.lua$", "")
  module = module:gsub("/", ".")
  
  M.reload_module(module)
end

-- Function to reload specific plugin
function M.reload_plugin(plugin_name)
  local module = "plugins." .. plugin_name
  M.reload_module(module)
  
  -- Try to reload the plugin with Lazy
  local ok, _ = pcall(function()
    require("lazy").reload({ plugins = { plugin_name } })
  end)
  
  if ok then
    vim.notify("Plugin reloaded: " .. plugin_name, vim.log.levels.INFO)
  end
end

-- Function to list and select plugin to reload
function M.select_and_reload_plugin()
  local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  local files = vim.fn.globpath(plugins_dir, "*.lua", false, true)
  
  local plugins = {}
  for _, file in ipairs(files) do
    local plugin_name = vim.fn.fnamemodify(file, ":t:r")
    table.insert(plugins, plugin_name)
  end
  
  vim.ui.select(plugins, {
    prompt = "Select plugin to reload:",
  }, function(choice)
    if choice then
      M.reload_plugin(choice)
    end
  end)
end

-- Function to reload and source current file
function M.source_current()
  local current_file = vim.fn.expand("%:p")
  
  if current_file:match("%.lua$") then
    -- For Lua files, reload as module
    M.reload_current_file()
  elseif current_file:match("%.vim$") then
    -- For Vim files, just source them
    vim.cmd("source %")
    vim.notify("Sourced: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
  else
    vim.notify("Not a Lua or Vim file", vim.log.levels.WARN)
  end
end

-- Create commands
vim.api.nvim_create_user_command("ReloadConfig", M.reload_config, { desc = "Reload entire Neovim configuration" })
vim.api.nvim_create_user_command("ReloadModule", function(opts)
  M.reload_module(opts.args)
end, { nargs = 1, desc = "Reload specific module" })
vim.api.nvim_create_user_command("ReloadPlugin", function(opts)
  if opts.args == "" then
    M.select_and_reload_plugin()
  else
    M.reload_plugin(opts.args)
  end
end, { nargs = "?", desc = "Reload specific plugin" })
vim.api.nvim_create_user_command("SourceCurrent", M.source_current, { desc = "Source/reload current file" })

-- Set up keymaps
vim.keymap.set("n", "<leader>rr", M.reload_config, { desc = "Reload entire config" })
vim.keymap.set("n", "<leader>rs", M.source_current, { desc = "Source current file" })
vim.keymap.set("n", "<leader>rp", M.select_and_reload_plugin, { desc = "Reload plugin" })
vim.keymap.set("n", "<leader>rf", M.reload_current_file, { desc = "Reload current file as module" })

-- Auto-reload on save for config files
local reload_group = vim.api.nvim_create_augroup("ConfigReload", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = reload_group,
  pattern = vim.fn.stdpath("config") .. "/lua/plugins/*.lua",
  callback = function()
    local file = vim.fn.expand("%:t:r")
    vim.notify("Auto-reloading plugin: " .. file, vim.log.levels.INFO)
    M.reload_plugin(file)
  end,
  desc = "Auto-reload plugin files on save"
})

return M