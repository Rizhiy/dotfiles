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
    end,
}
