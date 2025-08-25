return {
  "pocco81/true-zen.nvim",
  lazy = false,
  config = function()
    require("true-zen").setup({
      modes = {
        ataraxis = {
          shade = "dark",
          backdrop = 0,
          minimum_writing_area = {
            width = 70,
            height = 44,
          },
          quit_untoggles = true,
          padding = {
            left = 52,
            right = 52,
            top = 0,
            bottom = 0,
          },
          callbacks = {
            open_pre = nil,
            open_pos = nil,
            close_pre = nil,
            close_pos = nil
          },
        },
        minimalist = {
          ignored_buf_types = { "nofile" },
          options = {
            number = false,
            relativenumber = false,
            showtabline = 0,
            signcolumn = "no",
            statusline = "",
            cmdheight = 1,
            laststatus = 0,
            showcmd = false,
            showmode = false,
            ruler = false,
            numberwidth = 1
          },
          callbacks = {
            open_pre = nil,
            open_pos = nil,
            close_pre = nil,
            close_pos = nil
          },
        },
        narrow = {
          run_ataraxis = true,
          callbacks = {
            open_pre = nil,
            open_pos = nil,
            close_pre = nil,
            close_pos = nil
          },
        },
        focus = {
          callbacks = {
            open_pre = nil,
            open_pos = nil,
            close_pre = nil,
            close_pos = nil
          },
        }
      },
      integrations = {
        tmux = false,
        kitty = {
          enabled = false,
          font = "+3"
        },
        twilight = false,
        lualine = false
      },
    })

    local api = vim.api
    api.nvim_set_keymap("n", "<leader>zn", ":TZNarrow<CR>", { noremap = true, desc = "True Zen Narrow" })
    api.nvim_set_keymap("v", "<leader>zn", ":'<,'>TZNarrow<CR>", { noremap = true, desc = "True Zen Narrow" })
    api.nvim_set_keymap("n", "<leader>zf", ":TZFocus<CR>", { noremap = true, desc = "True Zen Focus" })
    api.nvim_set_keymap("n", "<leader>zm", ":TZMinimalist<CR>", { noremap = true, desc = "True Zen Minimalist" })
    api.nvim_set_keymap("n", "<leader>za", ":TZAtaraxis<CR>", { noremap = true, desc = "True Zen Ataraxis" })
  end,
}