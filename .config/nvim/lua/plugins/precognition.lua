return {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    config = function()
        require("precognition").setup({ startVisible = false, showBlankVirtLine = false })

        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function() require("precognition").peek() end,
        })
    end,
}
