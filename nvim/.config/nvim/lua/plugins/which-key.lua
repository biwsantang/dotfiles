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
      
      -- Register basic groups
      wk.add({
        { "<leader>", group = "Leader" },
        { "<leader>f", group = "Find" },
        { "<leader>k", group = "Keyboard" },
        { "<leader>p", group = "Profile" },
        { "<leader>a", group = "AI/Claude" },
        { "<leader>w", group = "Window" },
      })
    end,
  },
}