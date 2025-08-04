return {{
    'nvim-tree/nvim-web-devicons',
    lazy = true
}, {
    'b0o/nvim-tree-preview.lua',
    dependencies = {'nvim-lua/plenary.nvim'},
    lazy = true
}, {
    'nvim-tree/nvim-tree.lua',
    config = function()
        local function my_on_attach(bufnr)
            local api = require 'nvim-tree.api'

            local function opts(desc)
                return {
                    desc = 'nvim-tree: ' .. desc,
                    buffer = bufnr,
                    noremap = true,
                    silent = true,
                    nowait = true
                }
            end

            local preview = require 'nvim-tree-preview'

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set('n', 'e', "", {
                buffer = bufnr
            })
            vim.keymap.del('n', 'e', {
                buffer = bufnr
            })

            vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
            vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Rename: Omit Filename'))

            vim.keymap.set('n', 'P', preview.watch, opts('Preview (Watch)'))

            return on_attach
        end

        require('nvim-tree').setup({
            on_attach = my_on_attach
        })
        -- Add toggle function
        local function toggle_tree_and_focus()
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

        -- Add nvim-tree keymaps
        vim.keymap.set("n", "<Leader>e", toggle_tree_and_focus, {
            noremap = true,
            silent = true
        })
        vim.keymap.set("n", "<Leader>E", function()
            require("nvim-tree.api").tree.close()
        end, {
            noremap = true,
            silent = true
        })
    end,
    dependencies = {'nvim-tree/nvim-web-devicons', 'b0o/nvim-tree-preview.lua', 'nvim-lua/plenary.nvim'},
}}

