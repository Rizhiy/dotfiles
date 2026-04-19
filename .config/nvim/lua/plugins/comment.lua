return {
    "numToStr/Comment.nvim",
    keys = {
        {
            "<C-_>",
            function() require("Comment.api").toggle.linewise.current() end,
            desc = "Toggle comment",
            mode = "n",
        },
        {
            "<C-/>",
            function() require("Comment.api").toggle.linewise.current() end,
            desc = "Toggle comment",
            mode = "n",
        },
        {
            "<C-_>",
            function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end,
            desc = "Toggle comment",
            mode = "x",
        },
        {
            "<C-/>",
            function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end,
            desc = "Toggle comment",
            mode = "x",
        },
    },
    opts = {
        mappings = {
            basic = false,
            extra = false,
        },
    },
}
