return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        modes = {
            search = {
                enabled = false,
            },
        },
    },
    keys = {
        {
            "s",
            function() require("flash").jump() end,
            desc = "Flash",
        },
        {
            "S",
            function() require("flash").treesitter() end,
            desc = "Flash Treesitter",
        },
    },
}
