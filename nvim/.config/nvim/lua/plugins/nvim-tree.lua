return {{
    'nvim-tree/nvim-web-devicons',
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
            
            -- Apply default mappings
            api.config.mappings.default_on_attach(bufnr)
            
            -- Remove nvim-tree's default 'e' keybinding to allow Colemak navigation
            vim.keymap.del('n', 'e', { buffer = bufnr })
            
            -- Add custom keybinding for rename basename (Colemak-friendly)
            vim.keymap.set('n', 'b', api.fs.rename_basename, {
                desc = 'nvim-tree: Rename basename',
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true
            })
        end
        
        require('nvim-tree').setup({
            on_attach = my_on_attach,
            view = {
                float = {
                    enable = true,
                    quit_on_focus_loss = true,
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
            git = {
                ignore = false,  -- Show files that are in .gitignore
            },
        })
        
        -- Simple toggle keybinding
        vim.keymap.set("n", "<leader>e", function()
            require("nvim-tree.api").tree.toggle()
        end, {
            noremap = true,
            silent = true,
            desc = "Toggle file explorer"
        })
    end,
    dependencies = {'nvim-tree/nvim-web-devicons'},
}}

