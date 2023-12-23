return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            current_line_blame = true,
            current_line_blame_opts = {
                delay = 100,
            },
        })
        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment", default = true })
    end,
}
