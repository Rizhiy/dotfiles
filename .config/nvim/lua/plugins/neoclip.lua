return {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
        { "kkharji/sqlite.lua", module = "sqlite" },
        { "nvim-telescope/telescope.nvim" },
    },
    event = "VeryLazy",
    keys = {
        { "<leader>fy", ":Telescope neoclip<cr>", desc = "Search yanks", silent = true },
        { "<leader>f@", ":Telescope macroscope<cr>", desc = "Search macros", silent = true },
    },
    opts = {
        enable_persistent_history = true,
        continuous_sync = true,
        keys = {
            telescope = {
                i = {
                    paste_behind = false,
                    replay = false,
                },
            },
        },
    },
}
