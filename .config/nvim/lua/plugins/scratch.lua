return {
    "LintaoAmons/scratch.nvim",
    keys = {
        { "<leader>sc", ":Scratch<CR>",         desc = "Create new ScratchPad",       silent = true },
        { "<leader>sn", ":ScratchWithName<CR>", desc = "Create ScratchPad with name", silent = true },
        { "<leader>sf", ":ScratchOpen<CR>",     desc = "Find existing scratchpad",    silent = true },
    },
    opts = {
        filetypes = { "py", "lua", "txt", "json" },
    },
}
