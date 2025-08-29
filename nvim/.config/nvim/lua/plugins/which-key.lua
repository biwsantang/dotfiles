return {
  {
    "folke/which-key.nvim",
    lazy = false,
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")
      
      -- Simple setup with defaults
      wk.setup({})
      
      -- Register basic groups and mappings
      wk.add({
        { "<leader>", group = "Leader" },
        { "<leader>f", group = "Find" },
        { "<leader>ff", desc = "Find files" },
        { "<leader>fa", desc = "Find all files (including hidden)" },
        { "<leader>fr", desc = "Ripgrep text search" },
        { "<leader>fb", desc = "Find buffers" },
        { "<leader>k", group = "Keyboard" },
        { "<leader>p", group = "Profile" },
        { "<leader>a", group = "AI/Claude" },
        { "<leader>ac", desc = "Toggle Claude" },
        { "<leader>ar", desc = "Resume Claude" },
        { "<leader>aC", desc = "Continue Claude" },
        { "<leader>ab", desc = "Add file" },
        { "<leader>as", desc = "Send selection to Claude", mode = "v" },
        { "<leader>aa", desc = "Accept diff" },
        { "<leader>w", group = "Window" },
        { "<leader>z", group = "Zen Mode" },
        { "<leader>za", desc = "True Zen Ataraxis" },
        { "<leader>zf", desc = "True Zen Focus" },
        { "<leader>zm", desc = "True Zen Minimalist" },
        { "<leader>zn", desc = "True Zen Narrow" },
        
        -- Treesitter Textobject Navigation
        { "]", group = "Next" },
        { "]f", desc = "Next function" },
        { "]c", desc = "Next class" },
        { "]a", desc = "Next parameter" },
        { "]b", desc = "Next block" },
        { "]i", desc = "Next conditional" },
        { "]l", desc = "Next loop" },
        { "]r", desc = "Next return" },
        { "]s", desc = "Next assignment" },
        { "]m", desc = "Next call" },
        { "]#", desc = "Next comment" },
        
        { "[", group = "Previous" },
        { "[f", desc = "Previous function" },
        { "[c", desc = "Previous class" },
        { "[a", desc = "Previous parameter" },
        { "[b", desc = "Previous block" },
        { "[i", desc = "Previous conditional" },
        { "[l", desc = "Previous loop" },
        { "[r", desc = "Previous return" },
        { "[s", desc = "Previous assignment" },
        { "[m", desc = "Previous call" },
        { "[#", desc = "Previous comment" },
        
        -- Repeat keys
        { ";", desc = "Repeat last movement forward" },
        { ",", desc = "Repeat last movement backward" },
        
        -- Hop.nvim mappings
        { "s", desc = "Hop Code Patterns", mode = { "n", "x", "o" } },
        { "S", desc = "Hop Treesitter Nodes", mode = { "n" } },
        { "f", desc = "Hop forward to char", mode = { "n", "x", "o" } },
        { "F", desc = "Hop backward to char", mode = { "n", "x", "o" } },
        { "t", desc = "Hop before char forward", mode = { "n", "x", "o" } },
        { "T", desc = "Hop before char backward", mode = { "n", "x", "o" } },
        { "<leader>h", group = "Hop" },
        { "<leader>hw", desc = "Hop to word" },
        { "<leader>hl", desc = "Hop to line" },
        { "<leader>hp", desc = "Hop to pattern" },
        { "<leader>hh", desc = "Hop to 2 chars" },
        { "<leader>ha", desc = "Hop anywhere" },
      })
    end,
  },
}