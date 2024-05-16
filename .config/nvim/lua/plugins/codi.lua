return {
    "metakirby5/codi.vim",
    lazy = true,
    config = function()
        vim.cmd("let g:codi#autocmd = 'None'")
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            pattern = "*/scratch.nvim/*",
            command = "CodiUpdate",
        })
    end,
}
