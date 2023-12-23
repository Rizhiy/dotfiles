local on_attach = function(_, bufnr)
    --  This function gets run when an LSP connects to a particular buffer.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>ds", ":Telescope diagnostics<CR>", "Show diagnostics")
    nmap("<leader>dt", ":TroubleToggle<CR>", "Show trouble")
    nmap("<leader>do", vim.diagnostic.open_float, "Open diagnostic")
    nmap("<leader>dp", vim.diagnostic.goto_prev, "Next diagnostic")
    nmap("<leader>dn", vim.diagnostic.goto_next, "Prev diagnostic")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Show Documentation")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
        -- Use VirtualText for transparency
        vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticVirtualText" .. type })
    end
    vim.cmd("hi NormalFloat guibg=None")
end

return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "stylua",
                "isort",
                "black",
                "yamlfix",
                "taplo",
                "prettier",
                "luacheck",
                "ruff",
                "yamllint",
                "jsonlint",
                "markdownlint",
            },
        })

        local servers = {
            pyright = {},
            ruff_lsp = {
                init_options = {
                    settings = {
                        args = {
                            "--config=" .. vim.fn.getcwd() .. "/pyproject.toml",
                        },
                    },
                },
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
