return {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
        vim.g.rustaceanvim = {
            server = {
                on_attach = require("rizhiy.utils").on_attach,
            },
        }
    end,
}