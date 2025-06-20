local utils = require("core.utils")

return {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		opts = {
			file_types = { 'markdown', 'codecompanion', 'Avante' },
		},
		ft = { 'markdown', 'codecompanion', 'Avante' },
		enabled = utils.not_in_vscode,
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'echasnovski/mini.nvim'
		},
	},
}
