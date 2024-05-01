return {
    "protex/better-digraphs.nvim",
    keys = {
        {
            "<leader>od",
            function() require("better-digraphs").digraphs("normal") end,
            desc = "Find digraph",
        },
        {
            "<leader>od",
            function() require("better-digraphs").digraphs("insert") end,
            desc = "Find digraph",
            mode = "i",
        },
    },
}
