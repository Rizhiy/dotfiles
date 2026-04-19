return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({
                    async = false,
                    lsp_fallback = true,
                })
            end,
            desc = "Format buffer",
        },
    },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            yaml = { "yamlfix" },
            markdown = { "prettier" },
            htmldjango = { "djlint" },
            json = { "prettier" },
            jsonc = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
        },
        format_on_save = {
            timeout_ms = 2000,
            lsp_fallback = true,
        },
    },
}
