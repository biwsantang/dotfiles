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
        { "<leader>ft", desc = "FZF Treesitter symbols" },
        { "<leader>fs", desc = "FZF Document symbols" },
        { "<leader>fS", desc = "FZF Workspace symbols" },
        { "<leader>fq", desc = "FZF Treesitter query (all nodes)" },
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
        
        -- Leap.nvim mappings
        { "s", desc = "Leap to Treesitter Nodes", mode = { "n", "x", "o" } },
        { "S", desc = "Leap Bidirectional", mode = { "n", "x", "o" } },
        { "gs", desc = "Leap to Windows", mode = { "n", "x", "o" } },
        { "R", desc = "Leap Treesitter Select", mode = { "x", "o" } },
        { "g;", desc = "Repeat Last Leap", mode = { "n", "x", "o" } },
        
        -- Reload mappings
        { "<leader>r", group = "Reload" },
        { "<leader>rr", desc = "Reload entire config" },
        { "<leader>rs", desc = "Source current file" },
        { "<leader>rp", desc = "Reload plugin" },
        { "<leader>rf", desc = "Reload current file as module" },
        
        -- Special yank for AI
        { "<leader>y", group = "Yank special" },
        { "<leader>yc", desc = "Yank with context for AI", mode = { "n", "v" } },
        { "<leader>yf", desc = "Yank function with context" },
        { "<leader>yg", desc = "Yank with git blame", mode = { "n", "v" } },
      })
    end,
  },
}