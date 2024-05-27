return {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "pgsql", "mysql" }, lazy = true },
        { "tpope/vim-dadbod",                     lazy = true },
    },
    keys = {
        { "<leader>Du", function() vim.cmd("tab DBUI") end, desc = "Open Database UI" },
    },
    init = function()
        -- Your DBUI configuration
        vim.g.db_ui_use_nerd_fonts = 1
    end,
}
