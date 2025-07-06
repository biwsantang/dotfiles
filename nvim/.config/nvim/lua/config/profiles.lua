local M = {}

-- Profile definitions
M.profiles = {
  minimal = {
    "colorschemes",
    "lightline",
  },
  
  dev = {
    "colorschemes",
    "lightline",
    "lsp",
    "treesitter",
    "fzf-lua",
    "nvim-tree",
    "plenary",
  },
  
  full = {
    "colorschemes",
    "lightline",
    "lsp",
    "treesitter",
    "fzf-lua",
    "nvim-tree",
    "plenary",
    "diffview",
    "render-markdown",
    "nvim-window",
    "claudecode",
    "zellij-nav",
  },
}

-- Get current profile from environment variable or default
function M.get_current_profile()
  local profile = os.getenv("NVIM_PROFILE") or "dev"
  if not M.profiles[profile] then
    vim.notify("Profile '" .. profile .. "' not found, using 'dev'", vim.log.levels.WARN)
    profile = "dev"
  end
  return profile
end

-- Get plugins for current profile
function M.get_plugins()
  local profile = M.get_current_profile()
  return M.profiles[profile] or M.profiles.dev
end

-- Check if plugin should be loaded
function M.should_load_plugin(plugin_name)
  local enabled_plugins = M.get_plugins()
  for _, plugin in ipairs(enabled_plugins) do
    if plugin == plugin_name then
      return true
    end
  end
  return false
end

-- Get profile info
function M.get_profile_info()
  local current = M.get_current_profile()
  local plugins = M.get_plugins()
  return {
    current = current,
    plugins = plugins,
    count = #plugins,
    available = vim.tbl_keys(M.profiles)
  }
end

return M