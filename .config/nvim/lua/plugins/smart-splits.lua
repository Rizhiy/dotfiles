return {
    "mrjones2014/smart-splits.nvim",
    dependencies = { "kwkarlwang/bufresize.nvim" },
    keys = {
        {
            "<C-left>",
            function() require("smart-splits").resize_left() end,
            desc = "Resize split left",
            silent = true,
        },
        {
            "<C-right>",
            function() require("smart-splits").resize_right() end,
            desc = "Resize split right",
            silent = true,
        },
        {
            "<C-up>",
            function() require("smart-splits").resize_up() end,
            desc = "Resize split up",
            silent = true,
        },
        {
            "<C-down>",
            function() require("smart-splits").resize_down() end,
            desc = "Resize split down",
            silent = true,
        },
    },
}
