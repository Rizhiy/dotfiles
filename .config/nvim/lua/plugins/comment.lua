return {
    "numToStr/Comment.nvim",
    keys = {
        {
            "<C-_>",
            ':lua require("Comment.api").toggle.linewise.current()<CR>j',
            mode = "n",
            silent = true,
            desc = "Comment line",
        },
        {
            "<C-_>",
            ':lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
            mode = "v",
            silent = true,
            desc = "Comment selection",
        },
    },
    opts = {
        mappings = {
            basic = false,
        },
    },
}
