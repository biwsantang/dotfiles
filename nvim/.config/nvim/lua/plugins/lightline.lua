local utils = require("core.utils")

return {
    {
        "itchyny/lightline.vim",
        lazy = false,
        enabled = utils.not_in_vscode,
    },
}
