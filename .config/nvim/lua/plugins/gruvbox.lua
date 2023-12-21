return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        -- Why are opts not working?
        require("gruvbox").setup({italic = {strings = false}})
        vim.o.background = "dark"
        vim.cmd.colorscheme("gruvbox")
    end,
}
