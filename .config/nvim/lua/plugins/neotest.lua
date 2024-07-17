return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
    },
    keys = {
        {
            "<leader>tm",
            function() require("neotest").run.run() end,
            desc = "Run nearest test",
        },
        {
            "<leader>tf",
            function() require("neotest").run.run(vim.fn.expand("%")) end,
            desc = "Run all test in the file",
        },
        {
            "<leader>ta",
            function() require("neotest").run.run(vim.fn.getcwd()) end,
            desc = "Run all test in the file",
        },
        {
            "<leader>tl",
            function() require("neotest").run.run_last() end,
            desc = "Run last test",
        },
        {
            "<leader>ts",
            function() require("neotest").summary.toggle() end,
            desc = "Toggle tests summary",
        },
        {
            "[t",
            function() require("neotest").jump.prev({ status = "failed" }) end,
            desc = "Jump to previous failed test",
        },
        {
            "]t",
            function() require("neotest").jump.next({ status = "failed" }) end,
            desc = "Jump to next failed test",
        },
    },
    -- Use function since adapters might not be installed on first run
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                    runner = "pytest",
                }),
            },
        })
    end,
}
