return {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        auto_reload = true,
    },
    keys = {
        {
            "<leader>co",
            ":Coverage<CR>",
            desc = "Show coverage",
            silent = true,
        },
        {
            "<leader>cr",
            ":CoverageHide<CR>:CoverageClear<CR>:Coverage<CR>",
            desc = "Reload coverage",
            silent = true,
        },
        {
            "<leader>cc",
            ":CoverageClear<CR>",
            desc = "Close coverage",
            silent = true,
        },
        {
            "<leader>cs",
            ":CoverageLoad<CR>:CoverageSummary<CR>",
            desc = "Show coverage summary",
            silent = true,
        },
        {
            "<leader>cp",
            function() require("coverage").jump_prev("uncovered") end,
            desc = "Jump to prev uncovered code",
            silent = true,
        },
        {
            "<leader>cn",
            function() require("coverage").jump_next("uncovered") end,
            desc = "Jump to next uncovered code",
            silent = true,
        },
    },
}
