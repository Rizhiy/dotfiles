return {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
        require("treesitter-context").setup({
            max_lines = 5,
            min_window_height = 30,
            mode = "topline",
            separator = "-"
        })
    end
}
