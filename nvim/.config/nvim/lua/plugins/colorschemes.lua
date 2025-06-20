local utils = require("core.utils")

return {
  -- add dracula
  { "Mofiqul/dracula.nvim" },
{
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false,
  enabled = utils.not_in_vscode,
  config = function()
    require('github-theme').setup({
      options = {
        transparent = true
      }
    })
		-- vim.cmd('colorscheme github_light')
  end,
},{ "f-person/auto-dark-mode.nvim",
	opts = {
		update_interval = 3000,
		set_dark_mode = function()
			vim.cmd("colorscheme dracula")
		end,
		set_light_mode = function()
			vim.cmd("colorscheme github_light")
		end,
	}}
}
