return {
    "LintaoAmons/scratch.nvim",
    dependencies = { "metakirby5/codi.vim" },
    keys = {
        { "<leader>sc", ":Scratch<CR>",           desc = "Create new ScratchPad",       silent = true },
        { "<leader>sn", ":ScratchWithName<CR>",   desc = "Create ScratchPad with name", silent = true },
        { "<leader>se", ":ScratchEditConfig<CR>", desc = "Edit ScratchPad config",      silent = true },
    },
    config = function()
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            pattern = "*/scratch.nvim/*",
            command = "Codi",
        })
    end,
}
