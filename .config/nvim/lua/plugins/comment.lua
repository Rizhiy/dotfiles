return {
    "terrortylor/nvim-comment",
    name = "nvim_comment",
    keys = {
        { "<C-_>", ":CommentToggle<CR>j", desc = "Toggle comment", mode = { "n", "v" }, silent = true },
    },
    opts = {
        create_mappings = false,
    },
}
