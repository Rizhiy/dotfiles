return {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
        require("peek").setup()
        local nmap = require("rizhiy.keys").nmap
        nmap("<leader>mp", require("peek").open, { desc = "Open Markdown Preview" })
        nmap("<leader>mP", require("peek").close, { desc = "Close Markdown Preview" })
    end,
}
