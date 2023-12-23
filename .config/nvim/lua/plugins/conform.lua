return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                })
            end,
            desc = "Format file (or range in visual mode)",
        },
    },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = function(bufnr)
                if require("conform").get_formatter_info("ruff_fix", bufnr).available then
                    return { "ruff_fix", "ruff_format" }
                else
                    return { "isort", "black" }
                end
            end,
            yaml = { "yamlfix" },
            toml = { "taplo" },
            json = { "prettier" },
            markdown = { "prettier" },
            ["*"] = { "trim_whitespace" },
        },
        format_on_save = {
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
        },
    },
}
