return {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
    config = function()
        require("treesitter-context").setup({
            max_lines = 5,
            min_window_height = 30,
            separator = "-",
        })
    end,
}
