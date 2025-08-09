return {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local servers = {
            pyright = {
                -- Using Ruff's import organizer
                disableOrganizeImports = true,
            },
            ruff = {
                cmd = { "ruff", "server", "--preview", "--config", vim.fn.getcwd() .. "/pyproject.toml" },
            },
            html = {},
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                    diagnostics = {
                        disable = { "missing-fields" },
                    },
                },
            },
            taplo = {},
            yamlls = {},
            jsonls = {},
            bashls = {},
        }
        require("mason").setup({
            ui = {
                border = require("rizhiy.border").Border(),
            },
        })

        local mason_lsp_config = require("mason-lspconfig")
        mason_lsp_config.setup({
            ensure_installed = vim.tbl_keys(servers),
            automatic_installation = true,
        })
    end,
}
