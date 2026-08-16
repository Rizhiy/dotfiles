local has_tree_sitter_cli = vim.fn.executable("tree-sitter") == 1

local languages = {
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
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = has_tree_sitter_cli and ":TSUpdate" or nil,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.setup()
        if has_tree_sitter_cli then treesitter.install(languages) end

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                if require("rizhiy.utils").is_large_file(args.buf) then return end

                local language = vim.treesitter.language.get_lang(args.match)
                if not vim.list_contains(languages, language) then return end

                local parser_available = pcall(vim.treesitter.start, args.buf, language)
                if parser_available then vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
            end,
        })

        vim.cmd("hi TreesitterContext guibg=None")
    end,
}
