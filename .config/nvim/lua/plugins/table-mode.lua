return {
    "dhruvasagar/vim-table-mode",
    keys = {
        { "<leader>mt", ":TableModeToggle<CR>", desc = "Toggle Table mode" },
    },
    config = function() vim.cmd("let g:table_mode_corner='|'") end,
}
