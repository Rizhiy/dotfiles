return {
    "protex/better-digraphs.nvim",
    keys = {
        {
            "<leader>od",
            function() require("better-digraphs").digraphs("normal") end,
            desc = "Find digraph",
        },
        {
            -- Can't remap <C-k> directly since it will be used to insert digraph by the plugin
            "<C-k><leader>",
            function() require("better-digraphs").digraphs("insert") end,
            desc = "Find digraph",
            mode = "i",
        },
    },
}
