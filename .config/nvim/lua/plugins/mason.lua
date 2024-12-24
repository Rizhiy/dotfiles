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
        require("mason").setup({
            ui = {
                border = require("rizhiy.border").Border(),
            },
        })

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

        local mason_lsp_config = require("mason-lspconfig")
        mason_lsp_config.setup({
            ensure_installed = vim.tbl_keys(servers),
            automatic_installation = true,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        local border = require("rizhiy.border").Border
        mason_lsp_config.setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities,
                    on_attach = require("rizhiy.utils").on_attach,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                    handlers = {
                        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border() }),
                        ["textDocument/signatureHelp"] = vim.lsp.with(
                            vim.lsp.handlers.signature_help,
                            { border = border() }
                        ),
                    },
                })
            end,
        })
    end,
}
