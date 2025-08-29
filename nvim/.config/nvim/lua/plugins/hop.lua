return {
  {
    'smoka7/hop.nvim',
    version = "*",
    lazy = false,
    config = function()
      local hop = require('hop')
      
      -- Setup hop with optimized settings
      hop.setup({
        keys = 'asdghklqwertyuiopzxcvbnmfj',
        quit_key = '<ESC>',
        case_insensitive = false,
        multi_windows = true,
        uppercase_labels = false,
        -- Disable the dim effect for better visibility
        dim_unmatched = false,
      })
      
      -- Define keymaps for hop
      local directions = require('hop.hint').HintDirection
      
      -- Jump to code patterns (similar to treesitter nodes but shows all)
      vim.keymap.set('n', 's', function()
        -- Pattern that matches common code structures
        -- This will match function names, variable names, keywords, etc.
        hop.hint_patterns({}, [[\v(<function>|<if>|<for>|<while>|<return>|<class>|<def>|<const>|<let>|<var>|\w+\(|\w+\s*\=|\w+\s*:)]])
      end, { desc = "Hop Code Patterns" })
      
      -- Alternative: regular hop treesitter (limited)
      vim.keymap.set('n', 'S', function()
        require('hop-treesitter').hint_nodes()
      end, { desc = "Hop Treesitter Nodes" })
      
      -- Word jumps
      vim.keymap.set('n', '<leader>hw', function()
        hop.hint_words()
      end, { desc = "Hop to word" })
      
      -- Line jumps
      vim.keymap.set('n', '<leader>hl', function()
        hop.hint_lines()
      end, { desc = "Hop to line" })
      
      -- Pattern jump (like / search but with hop)
      vim.keymap.set('n', '<leader>hp', function()
        hop.hint_patterns()
      end, { desc = "Hop to pattern" })
      
      -- Character jumps (f/F replacement)
      vim.keymap.set({'n', 'x', 'o'}, 'f', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, { desc = "Hop forward to char" })
      
      vim.keymap.set({'n', 'x', 'o'}, 'F', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, { desc = "Hop backward to char" })
      
      -- t/T motions
      vim.keymap.set({'n', 'x', 'o'}, 't', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
      end, { desc = "Hop before char forward" })
      
      vim.keymap.set({'n', 'x', 'o'}, 'T', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
      end, { desc = "Hop before char backward" })
      
      -- Two character search
      vim.keymap.set('n', '<leader>hh', function()
        hop.hint_char2()
      end, { desc = "Hop to 2 chars" })
      
      -- Anywhere jump (all visible text)
      vim.keymap.set('n', '<leader>ha', function()
        hop.hint_anywhere()
      end, { desc = "Hop anywhere" })
      
      -- Visual mode and operator-pending mode support
      vim.keymap.set('x', 's', function()
        hop.hint_patterns({}, [[\v(<function>|<if>|<for>|<while>|<return>|<class>|<def>|<const>|<let>|<var>|\w+\(|\w+\s*\=|\w+\s*:)]])
      end, { desc = "Hop Code Patterns" })
      
      vim.keymap.set('o', 's', function()
        hop.hint_patterns({ inclusive_jump = true }, [[\v(<function>|<if>|<for>|<while>|<return>|<class>|<def>|<const>|<let>|<var>|\w+\(|\w+\s*\=|\w+\s*:)]])
      end, { desc = "Hop Code Patterns" })
    end,
  },
}