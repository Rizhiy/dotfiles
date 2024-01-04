return {
    "numToStr/Comment.nvim",
    keys = {
        {
            "<C-_>",
            function()
                require("Comment.api").toggle.linewise.current()
                require("rizhiy.keys").press("j", "n")
            end,
            mode = "n",
            silent = true,
            desc = "Comment line",
        },
        {
            "<C-_>",
            function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end,
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
