return {
  {
    "ggandor/leap.nvim",
    lazy = false,
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      local leap = require('leap')
      
      -- Configure leap
      leap.opts = {
        case_sensitive = false,
        substitute_chars = { ['\r'] = '¬' },
        special_keys = {
          repeat_search = '<enter>',
          next_phase_one_target = '<enter>',
          next_target = {'<enter>', ';'},
          prev_target = {'<tab>', ','},
          next_group = '<space>',
          prev_group = '<tab>',
          multi_accept = '<enter>',
          multi_revert = '<backspace>',
        },
      }
      
      -- Custom function to get ALL treesitter nodes as leap targets
      local function get_treesitter_targets()
        local winid = vim.api.nvim_get_current_win()
        local wininfo = vim.fn.getwininfo(winid)[1]
        local bufnr = vim.api.nvim_win_get_buf(winid)
        
        local parser = vim.treesitter.get_parser(bufnr)
        if not parser then return {} end
        
        local tree = parser:parse()[1]
        if not tree then return {} end
        
        local root = tree:root()
        
        -- Get visible range
        local top_line = vim.fn.line('w0') - 1
        local bot_line = vim.fn.line('w$') - 1
        
        local targets = {}
        local seen = {}
        
        -- Traverse all nodes
        local function traverse(node)
          local start_row, start_col = node:start()
          
          -- Only include visible nodes
          if start_row >= top_line and start_row <= bot_line then
            local key = start_row .. ":" .. start_col
            
            -- Include all unique positions
            if not seen[key] then
              seen[key] = true
              
              -- Create leap target
              local target = {
                pos = {start_row + 1, start_col + 1},  -- 1-indexed
                wininfo = wininfo,
              }
              
              table.insert(targets, target)
              
              -- Limit for performance
              -- if #targets >= 200 then
              --   return true
              -- end
            end
          end
          
          -- Traverse children
          for child in node:iter_children() do
            traverse(child)
            -- if traverse(child) then
            --   return true
            -- end
          end
        end
        
        traverse(root)
        
        return targets
      end
      
      -- Create a custom leap function for treesitter nodes
      local function leap_to_treesitter_nodes()
        require('leap').leap {
          target_windows = {vim.api.nvim_get_current_win()},
          targets = get_treesitter_targets,
        }
      end
      
      -- Set up keymaps
      vim.keymap.set({'n', 'x', 'o'}, 's', leap_to_treesitter_nodes, {desc = "Leap to Treesitter Nodes"})
      
      -- Alternative: use default leap for bidirectional search
      vim.keymap.set({'n', 'x', 'o'}, 'S', function()
        leap.leap { target_windows = {vim.api.nvim_get_current_win()} }
      end, {desc = "Leap Bidirectional"})
      
      -- Leap to windows
      vim.keymap.set({'n', 'x', 'o'}, 'gs', function()
        leap.leap { target_windows = vim.tbl_filter(
          function (win) return vim.api.nvim_win_get_config(win).focusable end,
          vim.api.nvim_tabpage_list_wins(0)
        )}
      end, {desc = "Leap to Windows"})
      
      -- Treesitter selection (visual and operator-pending mode)
      vim.keymap.set({'x', 'o'}, 'R', function()
        require('leap.treesitter').select()
      end, {desc = "Leap Treesitter Select"})
      
      -- Repeat last leap
      vim.keymap.set({'n', 'x', 'o'}, 'g;', function()
        require('leap').leap { repeat_keys = {';', ','} }
      end, {desc = "Repeat Last Leap"})
    end,
  },
}