local utils = require("core.utils")

return {
    {
        "sindrets/diffview.nvim",
        enabled = utils.not_in_vscode,
    }
}
