return {
  {
    "ggandor/leap.nvim",
    lazy = false,
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      local leap = require('leap')
      
      -- Configure leap to use two-character labels for all targets
      leap.opts = {
        max_phase_one_targets = nil,  -- No limit on first phase targets
        highlight_unlabeled_phase_one_targets = true,  -- Show unlabeled targets with highlights
        max_highlighted_traversal_targets = 10,
        case_sensitive = false,
        equivalence_classes = { ' \t\r\n', },
        substitute_chars = {},
        -- Use a smaller set of labels to force two-character combinations
        -- This gives us 26 * 26 = 676 possible two-char combinations
        safe_labels = {},  -- No safe labels, force two-char from start
        labels = 'asfghjklqwertyuiopzxcvbnm',  -- 26 chars, will create 26*26=676 combinations
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
      
      -- Set leap to always use bidirectional two-character search for treesitter
      leap.setup {
        max_phase_one_targets = 0,  -- Force all targets to phase two (two-char labels)
      }
      
      -- Define highlight groups for labels
      vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { bold = true, fg = '#ff007c', bg = '#2d2d2d' })
      vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { bold = true, fg = '#00dfff', bg = '#2d2d2d' })
      
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
      
      -- Create a custom implementation with two-character labels
      local function leap_to_treesitter_nodes()
        local winid = vim.api.nvim_get_current_win()
        local bufnr = vim.api.nvim_win_get_buf(winid)
        
        local parser = vim.treesitter.get_parser(bufnr)
        if not parser then return end
        
        local tree = parser:parse()[1]
        if not tree then return end
        
        local root = tree:root()
        
        -- Get visible range
        local top_line = vim.fn.line('w0') - 1
        local bot_line = vim.fn.line('w$') - 1
        
        local positions = {}
        local seen = {}
        
        -- Traverse all nodes
        local function traverse(node)
          local start_row, start_col = node:start()
          
          if start_row >= top_line and start_row <= bot_line then
            local key = start_row .. ":" .. start_col
            
            if not seen[key] then
              seen[key] = true
              table.insert(positions, {
                row = start_row,
                col = start_col,
              })
            end
          end
          
          for child in node:iter_children() do
            traverse(child)
          end
        end
        
        traverse(root)
        
        if #positions == 0 then return end
        
        -- Create two-character labels
        local chars = 'asfghjklqwertyuiopzxcvbnm'
        local labels = {}
        
        -- Generate two-character combinations
        for i = 1, #chars do
          for j = 1, #chars do
            table.insert(labels, chars:sub(i,i) .. chars:sub(j,j))
            if #labels >= #positions then break end
          end
          if #labels >= #positions then break end
        end
        
        -- Create virtual text overlays for each position
        local ns_id = vim.api.nvim_create_namespace('leap_treesitter')
        vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
        
        local label_map = {}
        
        for i, pos in ipairs(positions) do
          if labels[i] then
            label_map[labels[i]] = pos
            
            -- Add virtual text with two-character label
            vim.api.nvim_buf_set_extmark(bufnr, ns_id, pos.row, pos.col, {
              virt_text = {{labels[i]:sub(1,1), 'LeapLabelPrimary'}, {labels[i]:sub(2,2), 'LeapLabelSecondary'}},
              virt_text_pos = 'overlay',
              priority = 1000,
              hl_mode = 'combine',
            })
          end
        end
        
        -- Show labels and wait for input
        vim.cmd('redraw')
        
        -- Get two characters
        local ok1, char1 = pcall(vim.fn.getchar)
        if not ok1 then
          vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
          return
        end
        
        local ok2, char2 = pcall(vim.fn.getchar)
        if not ok2 then
          vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
          return
        end
        
        -- Clear labels
        vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
        
        -- Jump to target
        local label = vim.fn.nr2char(char1) .. vim.fn.nr2char(char2)
        local target = label_map[label]
        
        if target then
          vim.api.nvim_win_set_cursor(winid, {target.row + 1, target.col})
        end
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