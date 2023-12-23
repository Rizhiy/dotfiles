return {
    "mbbill/undotree",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo Tree" } },
    config = function() vim.cmd("let g:undotree_WindowLayout = 2") end,
}
