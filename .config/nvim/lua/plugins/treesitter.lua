return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        {"nvim-treesitter/nvim-treesitter-context", opts={
            max_lines = 5,min_window_height = 30,
            mode = "topline"
        }},
    },
    build = ':TSUpdate',
    config = function()
        require("nvim-treesitter.configs").setup({
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-Space>",
                    node_incremental = "<C-Space>",
                    node_decremental = "<C-H>",
                },
            },
            ensure_installed = {"lua", "python", "rust", "yaml", "toml", "markdown", "markdown_inline", "regex", "bash"},
            highlight = { enable = true },
            indent = { enable = true },
        })
        vim.cmd("hi TreesitterContext guibg=None")
    end
}
