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
      })
    end,
  },
}