return {
    {
        "swaits/zellij-nav.nvim",
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<c-h>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "navigate left"  } },
            { "<c-n>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down"  } },
            { "<c-e>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up"    } },
            { "<c-i>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
        },
        opts = {},
    },
}