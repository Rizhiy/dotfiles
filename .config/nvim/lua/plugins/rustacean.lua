return {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    build = "rustup component add rust-analyzer",
    config = function()
        vim.g.rustaceanvim = {
            server = {
                on_attach = require("rizhiy.utils").on_attach,
            },
        }
    end,
}
