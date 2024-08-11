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
        })
        vim.cmd("MasonToolsInstall")
    end,
}
