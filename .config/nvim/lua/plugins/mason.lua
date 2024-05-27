local on_attach = function(_, bufnr)
    --  This function gets run when an LSP connects to a particular buffer.
    local nmap = function(keys, func, desc)
        if desc then desc = "LSP: " .. desc end
        -- NOTE: Do we need to pass buffer in here?
        require("rizhiy.keys").nmap(keys, func, { desc = desc, buffer = bufnr })
    end

    nmap("rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>ds", ":Telescope diagnostics<CR>", "Show diagnostics")
    nmap("<leader>dt", ":TroubleToggle<CR>", "Show trouble")
    nmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
    nmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
        -- Use VirtualText for transparency
        vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticVirtualText" .. type })
    end
end

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

        local servers = {
            pyright = {
                -- Using Ruff's import organizer
                disableOrganizeImports = true,
            },
            ruff = {
                cmd = { "ruff", "server", "--preview", "--config", vim.fn.getcwd() .. "/pyproject.toml" },
            },
            rust_analyzer = {},
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
                    on_attach = on_attach,
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
