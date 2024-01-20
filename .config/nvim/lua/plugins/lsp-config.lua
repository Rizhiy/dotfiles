return {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        { "folke/neodev.nvim", opts = { library = { plugins = { "nvim-dap-ui" }, types = true } } }, -- neovim completion
        { "antosha417/nvim-lsp-file-operations", opts = {} }, -- Neo-tree integration
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
        })
    end,
}
