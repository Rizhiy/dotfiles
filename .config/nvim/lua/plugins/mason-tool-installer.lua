return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    config = function()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "stylua",
                "luacheck",
                "yamllint",
                "actionlint",
                "yamlfix",
                "jsonlint",
                "markdownlint",
                "codespell",
                "prettier",
            },
            debounce_hours = 24,
        })
        require("mason-tool-installer").run_on_start()
    end,
}
