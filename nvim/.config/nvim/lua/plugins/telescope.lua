local utils = require("core.utils")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    enabled = utils.not_in_vscode,
    config = function()
      -- Add telescope keybindings
      require('telescope').setup{
        defaults = {
          file_ignore_patterns = {"%.git/", "node_modules/"}
        },
        pickers = {
          find_files = {
            hidden = true
          }
        }
      }
      local builtin = require('telescope.builtin')
      vim.keymap.set({ 'n', 'v' }, '<Leader>ff', builtin.find_files, { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fa', function()
        builtin.find_files({
          hidden = true,
          no_ignore = true
        })
      end, { noremap = true, silent = true })
    end,
  }
}
