return {
    "meznaric/key-analyzer.nvim",
    opts = {},
    keys = {
        {
            "<leader>k<leader>",
            function() require("key-analyzer").show("n", "<leader>") end,
            desc = "Show key map",
            silent = true,
        },
    },
}
