local function my_on_attach(bufnr)
	local api = require 'nvim-tree.api'
				
	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer =bufnr, noremap = true, silent = true, nowait = true }
	end

	local preview = require 'nvim-tree-preview'

	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set('n', 'e', "", { buffer = bufnr })
	vim.keymap.del('n', 'e', { buffer = bufnr })

	vim.keymap.set('n', 'i', api.node.open.edit, opts('Open'))
	vim.keymap.set('n', 'l', api.fs.rename_sub, opts('Rename: Omit Filename'))

	vim.keymap.set('n', 'P', preview.watch, opts('Preview (Watch)'))

	return on_attach
end
return {
	{
		'nvim-tree/nvim-web-devicons',
		lazy = true,
	},
	{
		'b0o/nvim-tree-preview.lua',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		lazy = true,
	},
	{
		'nvim-tree/nvim-tree.lua',
		config = function()
			require('nvim-tree').setup({
				on_attach = my_on_attach,
			})
		end,
		dependencies = {
			'nvim-tree/nvim-web-devicons',
		},
	}
}

