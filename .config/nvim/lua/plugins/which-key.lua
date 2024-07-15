return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    version = "^3.4",
    opts = {
        spec = {
            { "g",          group = "Go" },
            { "z",          group = "Folds" },
            { "<leader>b",  group = "Buffer" },
            { "<leader>c",  group = "Code" },
            { "<leader>d",  group = "Debugging" },
            { "<leader>f",  group = "Find" },
            { "<leader>g",  group = "Git" },
            { "<leader>gh", group = "Github" },
            { "<leader>h",  group = "Harpoon" },
            { "<leader>l",  group = "Lazy" },
            { "<leader>m",  group = "Markdown" },
            { "<leader>o",  group = "Other" },
            { "<leader>r",  group = "Run" },
            { "<leader>s",  group = "ScratchPad" },
            { "<leader>x",  group = "Snippets" },
        },
        sort = {
            "group",
            "alphanum",
        },
    },
}
