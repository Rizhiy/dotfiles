return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    keys = {
        -- Extract function supports only visual mode
        {
            "<leader>rf",
            function() require("refactoring").refactor("Extract Function") end,
            desc = "Extract Function",
            mode = "x",
        },
        -- Extract variable supports only visual mode
        {
            "<leader>rv",
            function() require("refactoring").refactor("Extract Variable") end,
            desc = "Extract Variable",
            mode = "x",
        },
    },
}
