return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('fzf-lua').setup{
        files = {
          fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules]],
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        },
      }
      
      local fzf = require('fzf-lua')
      vim.keymap.set({ 'n', 'v' }, '<Leader>ff', fzf.files, { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fa', function()
        fzf.files({ fd_opts = "--color=never --type f --hidden --follow --no-ignore" })
      end, { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fr', fzf.live_grep, { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fb', fzf.buffers, { noremap = true, silent = true })
    end,
  }
}
