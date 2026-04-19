return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            lua = { "selene" },
            yaml = { "yamllint", "actionlint" },
            markdown = { "markdownlint" },
            python = { "codespell" },
            htmldjango = { "djlint" },
        }

        local group = vim.api.nvim_create_augroup("rizhiy-lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = group,
            callback = function() lint.try_lint() end,
        })
    end,
}
