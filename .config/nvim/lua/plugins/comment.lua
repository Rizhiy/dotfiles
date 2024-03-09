return {
    "terrortylor/nvim-comment",
    name = "nvim_comment",
    keys = {
        -- Different environments interpret forwardslash differently
        { "<C-_>", ":CommentToggle<CR>j", desc = "Toggle comment", mode = { "n", "v" }, silent = true },
        { "<C-/>", ":CommentToggle<CR>j", desc = "Toggle comment", mode = { "n", "v" }, silent = true },
    },
    opts = {
        create_mappings = false,
    },
}
