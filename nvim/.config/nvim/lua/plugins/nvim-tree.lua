return {{
    'nvim-tree/nvim-web-devicons',
    lazy = true
}, {
    'b0o/nvim-tree-preview.lua',
    dependencies = {'nvim-lua/plenary.nvim'},
    lazy = true
}, {
    'nvim-tree/nvim-tree.lua',
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose", "NvimTreeFocus" },
    keys = {
        { "<leader>e", desc = "Toggle file explorer" },
    },
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
            vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
            vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New Tab'))
            vim.keymap.set('n', 'T', function()
                api.node.open.tab()
                vim.cmd('tabprev')
            end, opts('Open: New Tab (Background)'))

            vim.keymap.set('n', 'P', preview.watch, opts('Preview (Watch)'))
            vim.keymap.set('n', '<Esc>', preview.unwatch, opts('Close Preview'))
            vim.keymap.set('n', 'p', function()
                local ok, node = pcall(api.tree.get_node_under_cursor)
                if ok and node then
                    if node.type == 'file' then
                        preview.node(node, { toggle_focus = false })
                    end
                end
            end, opts('Preview'))

            return on_attach
        end

        require('nvim-tree').setup({
            on_attach = my_on_attach,
            view = {
                float = {
                    enable = true,
                    open_win_config = {
                        relative = "editor",
                        border = "rounded",
                        width = 50,
                        height = 25,
                        row = 5,
                        col = 10,
                    },
                },
            },
            update_focused_file = {
                enable = true,
                update_root = false,
                ignore_list = {},
            },
            sync_root_with_cwd = true,
        })
        -- Add nvim-tree keymaps - simple toggle for floating window
        vim.keymap.set("n", "<leader>e", function()
            require("nvim-tree.api").tree.toggle()
            -- Auto-enable preview watch mode when opening nvim-tree
            vim.defer_fn(function()
                local view = require("nvim-tree.view")
                if view.is_visible() then
                    require("nvim-tree-preview").watch()
                end
            end, 100)
        end, {
            noremap = true,
            silent = true,
            desc = "Toggle file explorer"
        })
    end,
    dependencies = {'nvim-tree/nvim-web-devicons', 'b0o/nvim-tree-preview.lua', 'nvim-lua/plenary.nvim'},
}}

