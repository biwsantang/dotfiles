local utils = require("core.utils")

return {
    {
        "yorickpeterse/nvim-window",
        enabled = utils.not_in_vscode,
        config = function()
            vim.keymap.set("n", "<Leader>wn", [[<cmd>lua require("nvim-window").pick()<cr>]], { noremap = true, silent = true })
        end,
    },
}
