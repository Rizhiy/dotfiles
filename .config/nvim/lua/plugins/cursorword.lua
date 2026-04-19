return {
    "nvim-mini/mini.cursorword",
    event = "VeryLazy",
    opts = {
        delay = 100,
    },
    init = function()
        local autocmd = vim.api.nvim_create_autocmd

        autocmd("FileType", {
            pattern = { "alpha", "help", "lazy", "mason", "TelescopePrompt", "Trouble" },
            callback = function(args) vim.b[args.buf].minicursorword_disable = true end,
        })

        autocmd({ "BufEnter", "WinEnter" }, {
            callback = function(args)
                if require("rizhiy.utils").is_large_file(args.buf) then vim.b[args.buf].minicursorword_disable = true end
            end,
        })
    end,
}
