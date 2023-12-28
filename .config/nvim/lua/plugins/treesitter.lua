return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-Space>",
                    node_incremental = "<C-Space>",
                    node_decremental = "<BS>",
                    scope_incremental = false,
                },
            },
            ensure_installed = {
                "vim",
                -- languages
                "lua",
                "python",
                "rust",
                "bash",
                -- data
                "markdown",
                "markdown_inline",
                "json",
                "yaml",
                "toml",
                -- other
                "regex",
                "sql",
                "dockerfile",
                "gitignore",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
        vim.cmd("hi TreesitterContext guibg=None")
    end,
}
