return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('fzf-lua').setup{
        global_git_icons = false,
        file_ignore_patterns = {
          "node_modules",
          ".git",
          ".next",
          "dist",
          "build"
        },
        files = {
          fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude .next --exclude dist --exclude build]],
          rg_opts = [[--files --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!.next/*" --glob "!dist/*" --glob "!build/*"]],
          find_opts = [[-type f -not -path "*/node_modules/*" -not -path "*/.git/*"]],
        },
        grep = {
          rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!.next/*" --glob "!dist/*" --glob "!build/*" -e]],
          exclude = {"node_modules", ".git", ".next", "dist", "build"},
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
