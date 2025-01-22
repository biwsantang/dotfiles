return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			-- Add telescope keybindings
			local telescope = require('telescope.builtin')
			vim.keymap.set({ 'n', 'v' }, '<Leader>ff', telescope.find_files, { noremap = true, silent = true })
		end,
	}
}
