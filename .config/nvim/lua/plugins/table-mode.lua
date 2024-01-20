return {
    "dhruvasagar/vim-table-mode",
    keys = {
        { "<leader>mt", ":TableModeToggle<CR>", desc = "Toggle Table mode", silent = true },
    },
    config = function() vim.cmd("let g:table_mode_corner='|'") end,
}
