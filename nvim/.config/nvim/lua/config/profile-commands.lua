local profiles = require("config.profiles")

-- Command to show current profile info
vim.api.nvim_create_user_command("ProfileInfo", function()
  local info = profiles.get_profile_info()
  local msg = {
    "Current Profile: " .. info.current,
    "Loaded Plugins: " .. info.count,
    "Available Profiles: " .. table.concat(info.available, ", "),
    "",
    "Enabled Plugins:"
  }
  
  for _, plugin in ipairs(info.plugins) do
    table.insert(msg, "  • " .. plugin)
  end
  
  vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO)
end, {
  desc = "Show current profile information"
})

-- Command to set profile (requires restart)
vim.api.nvim_create_user_command("ProfileSet", function(opts)
  local profile = opts.args
  if not profiles.profiles[profile] then
    vim.notify("Profile '" .. profile .. "' not found. Available: " .. table.concat(vim.tbl_keys(profiles.profiles), ", "), vim.log.levels.ERROR)
    return
  end
  
  -- Write profile to a temp file for shell script
  local temp_file = vim.fn.tempname()
  local file = io.open(temp_file, "w")
  if file then
    file:write("export NVIM_PROFILE=" .. profile .. "\n")
    file:close()
    
    vim.notify("Profile set to: " .. profile, vim.log.levels.INFO)
    vim.notify("Restart nvim or run: source " .. temp_file .. " && nvim", vim.log.levels.INFO)
  else
    vim.notify("Failed to write profile setting", vim.log.levels.ERROR)
  end
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(profiles.profiles)
  end,
  desc = "Set profile (requires restart)"
})

-- Command to quickly restart with different profile
vim.api.nvim_create_user_command("ProfileRestart", function(opts)
  local profile = opts.args
  if not profiles.profiles[profile] then
    vim.notify("Profile '" .. profile .. "' not found. Available: " .. table.concat(vim.tbl_keys(profiles.profiles), ", "), vim.log.levels.ERROR)
    return
  end
  
  -- Set environment variable and restart
  vim.env.NVIM_PROFILE = profile
  vim.notify("Restarting with profile: " .. profile, vim.log.levels.INFO)
  vim.defer_fn(function()
    vim.cmd("qa")
  end, 500)
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_keys(profiles.profiles)
  end,
  desc = "Restart nvim with different profile"
})

-- Quick profile switching keymaps
vim.keymap.set("n", "<leader>pm", "<cmd>ProfileRestart minimal<CR>", { desc = "Restart with minimal profile" })
vim.keymap.set("n", "<leader>pd", "<cmd>ProfileRestart dev<CR>", { desc = "Restart with dev profile" })
vim.keymap.set("n", "<leader>pf", "<cmd>ProfileRestart full<CR>", { desc = "Restart with full profile" })
vim.keymap.set("n", "<leader>pi", "<cmd>ProfileInfo<CR>", { desc = "Show profile info" })

-- Note: VSCode profile is auto-detected, no manual switching needed