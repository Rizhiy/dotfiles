return {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
        { "<leader>gC", ":Git commit<CR>", desc = "Git commit", silent = true },
        { "<leader>gP", ":Git pull<CR>",   desc = "Git pull",   silent = true },
    },
}
