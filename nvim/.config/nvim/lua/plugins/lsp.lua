return {
  {
    'williamboman/mason.nvim',
    config = function()
        require('mason').setup({})
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
        require('mason-lspconfig').setup({
            ensure_installed = { 'vtsls', 'lua_ls' },
            automatic_installation = true,
        })
    end
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
        -- LSP capabilities setup
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- Configure diagnostics to show inline
        vim.diagnostic.config({
            virtual_text = true,  -- Enable inline virtual text
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
        
        -- Setup language servers using new vim.lsp.config API (Neovim 0.11+)
        local mason_bin = vim.fn.stdpath('data') .. '/mason/bin'
        
        -- Setup vtsls (TypeScript/JavaScript)
        vim.lsp.config.vtsls = {
            cmd = { mason_bin .. '/vtsls', '--stdio' },
            filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
            root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
            capabilities = capabilities,
            settings = {
                typescript = {
                    inlayHints = {
                        parameterNames = { enabled = "all" },
                        parameterTypes = { enabled = true },
                        variableTypes = { enabled = true },
                        propertyDeclarationTypes = { enabled = true },
                        functionLikeReturnTypes = { enabled = true },
                        enumMemberValues = { enabled = true },
                    },
                    preferences = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    }
                },
                javascript = {
                    inlayHints = {
                        parameterNames = { enabled = "all" },
                        parameterTypes = { enabled = true },
                        variableTypes = { enabled = true },
                        propertyDeclarationTypes = { enabled = true },
                        functionLikeReturnTypes = { enabled = true },
                        enumMemberValues = { enabled = true },
                    },
                    preferences = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    }
                },
                vtsls = {
                    enableMoveToFileCodeAction = true,
                    experimental = {
                        completion = {
                            enableServerSideFuzzyMatch = true
                        }
                    }
                }
            }
        }
        
        -- Setup lua_ls
        vim.lsp.config.lua_ls = {
            cmd = { mason_bin .. '/lua-language-server' },
            filetypes = { 'lua' },
            root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
            capabilities = capabilities,
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                        setType = true,
                        paramType = true,
                        paramName = "All",
                        semicolon = "SameLine",
                        arrayIndex = "Enable",
                    },
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            }
        }
        
        -- Enable the configured servers
        vim.lsp.enable('vtsls')
        vim.lsp.enable('lua_ls')
        
        -- Enable inlay hints globally by default
        vim.lsp.inlay_hint.enable(true)
        
        -- LSP keybindings
        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local opts = {
                    buffer = event.buf
                }
                
                -- Ensure inlay hints are enabled for this buffer
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.supports_method('textDocument/inlayHint') then
                    -- Force enable inlay hints
                    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                    
                    -- For vtsls, we need to make sure the server is ready
                    if client.name == 'vtsls' then
                        vim.defer_fn(function()
                            vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
                            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                            vim.notify(string.format("Inlay hints refreshed for %s in buffer %d", client.name, event.buf), vim.log.levels.INFO)
                        end, 1000)
                    else
                        vim.notify(string.format("Inlay hints enabled for %s in buffer %d", client.name, event.buf), vim.log.levels.INFO)
                    end
                end
                
                -- Toggle inlay hints with <leader>ih
                vim.keymap.set('n', '<leader>ih', function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
                end, { buffer = event.buf, desc = 'Toggle inlay hints' })
                vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                
                -- Auto-hover on cursor hold
                vim.api.nvim_create_autocmd("CursorHold", {
                    buffer = event.buf,
                    callback = function()
                        local clients = vim.lsp.get_clients({ bufnr = event.buf })
                        if #clients > 0 then
                            vim.lsp.buf.hover()
                        end
                    end,
                })
                
                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            end
        })
        
        -- Debug command for inlay hints
        vim.api.nvim_create_user_command('InlayHintsDebug', function()
            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })
            
            print("=== Inlay Hints Debug Info ===")
            print(string.format("Buffer: %d", bufnr))
            print(string.format("Filetype: %s", vim.bo[bufnr].filetype))
            print(string.format("Global inlay hints enabled: %s", vim.lsp.inlay_hint.is_enabled() and "YES" or "NO"))
            print(string.format("Buffer inlay hints enabled: %s", vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) and "YES" or "NO"))
            
            for _, client in ipairs(clients) do
                print(string.format("\nClient: %s (ID: %d)", client.name, client.id))
                print(string.format("  Supports inlay hints: %s", client.supports_method('textDocument/inlayHint') and "YES" or "NO"))
                
                if client.name == 'vtsls' and client.config.settings then
                    local ts_hints = client.config.settings.typescript and client.config.settings.typescript.inlayHints
                    if ts_hints then
                        print("  TypeScript inlay hints settings:")
                        print(string.format("    parameterNames: %s", vim.inspect(ts_hints.parameterNames)))
                        print(string.format("    variableTypes: %s", vim.inspect(ts_hints.variableTypes)))
                    end
                end
            end
            
            -- Try to force refresh
            print("\nForcing inlay hints refresh...")
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            print("Refresh complete!")
        end, { desc = "Debug inlay hints status" })
    end
  }
}
