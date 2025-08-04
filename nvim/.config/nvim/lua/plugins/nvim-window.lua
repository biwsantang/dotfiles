return {
    {
        "yorickpeterse/nvim-window",
        config = function()
            vim.keymap.set("n", "<Leader>wn", [[<cmd>lua require("nvim-window").pick()<cr>]], { noremap = true, silent = true })
        end,
    },
}
