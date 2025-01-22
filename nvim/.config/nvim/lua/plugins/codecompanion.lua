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
			-- Add CodeCompanion keymaps
			vim.keymap.set("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
			vim.keymap.set("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
			vim.keymap.set("n", "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
			vim.keymap.set("v", "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
			vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"github/copilot.vim",
		},
	},
}
