local my_snippets_dir = vim.fn.stdpath("config") .. "/snippets"
return { -- Autocompletion
    "saghen/blink.cmp",
    version = "1.*",
    event = "VeryLazy",
    dependencies = {
        "neovim/nvim-lspconfig",

        -- Snippet engine and snippets
        { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
        "rafamadriz/friendly-snippets",

        -- Snippet editing
        {
            "chrisgrieser/nvim-scissors",
            opts = { snippetDir = my_snippets_dir },
        },

        -- Copilot as blink provider
        "fang2hou/blink-copilot",
    },
    opts_extend = { "sources.default" },
    keys = {
        {
            "<leader>xa",
            function() require("scissors").addNewSnippet() end,
            desc = "Add new snippet",
            mode = { "v" },
        },
        { "<leader>xe", function() require("scissors").editSnippet() end, desc = "Edit existing snippet" },
    },
    opts = {
        appearance = {
            highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
        },
        keymap = {
            preset = "none",
            -- Doesn't work, so just unbind for now
            -- ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<Tab>"] = { "select_and_accept", "snippet_forward" },
            ["<S-Tab>"] = { "snippet_backward" },
            ["<C-y>"] = { "accept" },
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide" },
        },
        completion = {
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false,
                },
            },
            menu = {
                border = require("rizhiy.border").Border(),
                winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None",
            },
            documentation = {
                auto_show = true,
                window = {
                    border = require("rizhiy.border").Border(),
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,EndOfBuffer:NormalFloat",
                },
            },
        },
        snippets = {
            preset = "luasnip",
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "copilot" },
            providers = {
                copilot = {
                    name = "copilot",
                    module = "blink-copilot",
                    score_offset = 100,
                    async = true,
                },
            },
        },
    },
    config = function(_, opts)
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = { my_snippets_dir } })
        luasnip.config.setup({})
        require("blink.cmp").setup(opts)
    end,
}
