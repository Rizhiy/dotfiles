return {
    "mfussenegger/nvim-lint",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    keys = {
        {
            "<leader>cl",
            function()
                require("lint").try_lint()
            end,
            desc = "Lint current file",
        },
    },
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            lua = { "luacheck" },
            python = { "ruff" },
            yaml = { "yamllint" },
            json = { "jsonlint" },
            markdown = { "markdownlint" },
        }
        lint.linters.luacheck.args = { "--formatter", "plain", "--codes", "--ranges", "--globals", "vim", "-" }

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            callback = function(_)
                lint.try_lint()
            end,
        })
    end,
}
