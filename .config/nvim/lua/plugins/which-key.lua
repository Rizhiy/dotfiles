return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    version = "^3.4",
    opts = {
        preset = "modern",
        spec = {
            { "g", group = "Go" },
            { "z", group = "Folds" },
            { "<leader>b", group = "Buffer" },
            { "<leader>c", group = "Code" },
            { "<leader>d", group = "Debugging" },
            { "<leader>f", group = "Search" },
            { "<leader>g", group = "Git" },
            { "<leader>gh", group = "Github" },
            { "<leader>h", group = "Harpoon" },
            { "<leader>l", group = "Lazy" },
            { "<leader>m", group = "Markdown" },
            { "<leader>o", group = "Other" },
            { "<leader>r", group = "Run" },
            { "<leader>s", group = "ScratchPad" },
            { "<leader>x", group = "Snippets" },
        },
        sort = {
            "order",
            "group",
            "alphanum",
            "mod",
        },
        disable = {
            ft = {
                "floaterm",
            },
        },
        win = {
            padding = { 0, 0 },
        },
        layout = {
            width = { min = 0 },
            spacing = 2,
        },
        keys = {
            scroll_down = "<C-j>",
            scroll_up = "<C-k>",
        },
        expand = 1,
    },
}
