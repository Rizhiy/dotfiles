return {
    "hiphish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    enabled = false,
    config = function()
        vim.g.rainbow_delimiters = {
            highlight = {
                "RainbowDelimiterOrange",
                "RainbowDelimiterRed",
                "RainbowDelimiterYellow",
                "RainbowDelimiterGreen",
                "RainbowDelimiterBlue",
                "RainbowDelimiterViolet",
                "RainbowDelimiterCyan",
            },
        }
    end,
}
