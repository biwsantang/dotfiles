-- Enable syntax highlighting
vim.cmd('syntax on')

-- Enable true color support
vim.opt.termguicolors = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

-- Search settings
vim.opt.hlsearch = true

-- Show ruler
vim.opt.ruler = true

local map = vim.api.nvim_set_keymap
local mapOpts = { noremap = true, silent = true }

-- Key mappings
vim.keymap.set({'n', 'v'}, 'n', 'j', { noremap = true })
vim.keymap.set({'n', 'v'}, 'e', 'k', { noremap = true })
vim.keymap.set({'n', 'v'}, 'i', 'l', { noremap = true })
vim.keymap.set({'n', 'v'}, 'j', 'e', { noremap = true })
vim.keymap.set({'n', 'v'}, 'k', 'n', { noremap = true })
vim.keymap.set({'n', 'v'} , 'l', 'i', { noremap = true })

vim.keymap.set({'n', 'v'} , 'cl', 'ci', { noremap = true })
vim.keymap.set({'n', 'v'}, 'dl', 'di', { noremap = true })

-- vim.cmd('colorscheme github_light')

vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

require('config.lazy')

function toggle_tree_and_focus()
	local api = require('nvim-tree.api')
	local view = require('nvim-tree.view')

	if view.is_visible() then
		if view.get_winnr() == vim.api.nvim_get_current_win() then
			vim.cmd('wincmd l')
		else
			api.tree.focus()
		end
	else
		api.tree.open()
	end
end

map("n", "<Leader>e", [[<cmd>lua toggle_tree_and_focus()<cr>]], mapOpts)
map("n", "<Leader>E", [[<cmd>lua require("nvim-tree.api").tree.close()<cr>]], mapOpts)

map("n", "<Leader>wn", [[<cmd>lua require("nvim-window").pick()<cr>]], mapOpts)

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lspconfig_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
	)

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set('n', 'gd', [[<cmd>lua vim.lsp.buf.definition()<cr>]], opts)
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	end,
})

require('mason').setup({})
require('mason-lspconfig').setup({
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	},
})
