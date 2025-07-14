return {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = { "BufReadPre", "BufNewFile" },
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
                "rst",
            },
            auto_install = true,
            highlight = {
                enable = true,
                disable = function(_, buf) return require("rizhiy.utils").is_large_file(buf) end,
            },
            indent = { enable = true },
        })
        vim.cmd("hi TreesitterContext guibg=None")
    end,
}
