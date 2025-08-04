return {
  {
    "coder/claudecode.nvim",
    config = function()
      require("claudecode").setup({})
      
      -- Claude Code keymaps
      vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
      vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
      vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
      vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAddFile<cr>", { desc = "Add file" })
      vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })
      vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
    end,
  },
}