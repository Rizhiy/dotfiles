return {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    keys = {
        { "<leader>rs", ":LspRestart<CR>", desc = "Restart Server", silent = true },
    },
    config = function(_)
        vim.diagnostic.config({
            float = {
                border = require("rizhiy.border").Border(),
            },
            virtual_text = {
                prefix = "●",
            },
        }, vim.api.nvim_create_namespace("neotest"))
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

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        for server_name, _ in pairs(servers) do
            vim.lsp.config(server_name, {
                capabilities = capabilities,
                on_attach = require("rizhiy.utils").on_attach,
                settings = servers[server_name],
                filetypes = (servers[server_name] or {}).filetypes,
            })
            vim.lsp.enable(server_name)
        end
    end,
}
