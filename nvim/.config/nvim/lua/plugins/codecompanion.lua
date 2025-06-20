local utils = require("core.utils")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
		enabled = utils.not_in_vscode,
	},
	{
		"github/copilot.vim",
		lazy = true,
		enabled = utils.not_in_vscode,
	},
	{
		"olimorris/codecompanion.nvim",
		lazy = false,
		enabled = utils.not_in_vscode,
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
