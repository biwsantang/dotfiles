return {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		opts = {
			file_types = { 'markdown', 'codecompanion', 'Avante' },
		},
		ft = { 'markdown', 'codecompanion', 'Avante' },
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'echasnovski/mini.nvim'
		},
	},
}
