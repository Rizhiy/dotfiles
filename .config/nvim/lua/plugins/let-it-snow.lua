return {
    "marcussimonsen/let-it-snow.nvim",
    event = "VeryLazy",
    opts = { delay = 250 },
    config = function(opts)
        require("let-it-snow").setup(opts)

        local snow = require("let-it-snow.snow")
        local autocmd = vim.api.nvim_create_autocmd
        autocmd({ "CursorHold" }, {
            callback = function() snow._let_it_snow() end,
        })
        autocmd({ "CursorMoved" }, {
            callback = function()
                local buf = vim.api.nvim_get_current_buf()
                if snow.running[buf] then snow.end_hygge(buf) end
            end,
        })
    end,
}
