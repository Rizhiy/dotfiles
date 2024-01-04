return {
    "LintaoAmons/scratch.nvim",
    keys = {
        { "<leader>sc", ":Scratch<CR>",           desc = "Create new ScratchPad" },
        { "<leader>sn", ":ScratchWithName<CR>",   desc = "Create ScratchPad with name" },
        { "<leader>so", ":ScratchOpen<CR>",       desc = "Open Existing ScratchPad" },
        { "<leader>se", ":ScratchEditConfig<CR>", desc = "Edit ScratchPad config" },
    },
    config = function()
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            pattern = "*/scratch.nvim/*",
            command = "Codi",
        })
    end,
}
