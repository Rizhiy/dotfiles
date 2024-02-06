return {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "markdown" },
    keys = {
        { "<leader>mp", function() require("peek").open() end, desc = "Open Preview",  ft = "markdown" },
        { "<leader>mP", function() require("peek").open() end, desc = "Close Preview", ft = "markdown" },
    },
    opts = {},
}
