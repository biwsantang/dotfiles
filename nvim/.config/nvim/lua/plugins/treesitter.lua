
local utils = require("core.utils")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = utils.not_in_vscode,
    -- ...existing code...
  }
}
