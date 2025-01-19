return {
	{
		"nvim-lua/plenary.nvim",
		lazy = true,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
	},
	{
		"github/copilot.vim",
		lazy = true,
	},
	{
		"olimorris/codecompanion.nvim",
		lazy = false,
		config = function()
			require("codecompanion").setup()
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"github/copilot.vim",
		},
	},
}
