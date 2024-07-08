local my_snippets_dir = vim.fn.stdpath("config") .. "/snippets"
return { -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        { "L3MON4D3/LuaSnip",   build = "make install_jsregexp" },
        "saadparwaiz1/cmp_luasnip",
        -- Adds a number of user-friendly snippets
        "rafamadriz/friendly-snippets",
        -- Snippet editing
        {
            "chrisgrieser/nvim-scissors",
            opts = { snippetDir = my_snippets_dir },
        },

        -- Adds LSP completion capabilities
        "hrsh7th/cmp-nvim-lsp",
        -- Other sources
        "hrsh7th/cmp-path",                                                             -- Paths
        "SergioRibera/cmp-dotenv",                                                      -- environment variables
        "hrsh7th/cmp-buffer",                                                           -- text in buffer
        { "petertriho/cmp-git", dependencies = { "petertriho/cmp-git" }, opts = true }, -- git completion

        -- Icons
        "onsails/lspkind.nvim",

        -- VIM cmd auto-complete
        "hrsh7th/cmp-cmdline",
    },
    keys = {
        {
            "<leader>xa",
            function() require("scissors").addNewSnippet() end,
            desc = "Add new snippet",
            mode = { "v" },
        },
        { "<leader>xe", function() require("scissors").editSnippet() end, desc = "Edit existing snippet" },
    },
    config = function(_)
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = { my_snippets_dir } })
        luasnip.config.setup({})

        local lspkind = require("lspkind")

        local border = require("rizhiy.border").Border
        cmp.setup({
            snippet = {
                expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            completion = {
                completeopt = "menu,menuone,noinsert,preview",
            },
            mapping = {
                ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    elseif cmp.visible() then
                        cmp.confirm()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                {
                    name = "path",
                    option = {
                        get_cwd = function() return vim.fn.getcwd() end,
                    },
                },
                { name = "dotenv" },
                { name = "buffer" },
            },
            formatting = {
                format = lspkind.cmp_format(),
            },
            window = {
                completion = cmp.config.window.bordered({
                    border = border(),
                }),
                documentation = cmp.config.window.bordered({
                    border = border(),
                }),
            },
        })

        cmp.setup.filetype({ "sql", "mysql", "pgsql" }, {
            sources = {
                { name = "vim-dadbod-completion" },
                { name = "buffer" },
            },
        })

        cmp.setup.filetype({ "gitcommit" }, {
            sources = {
                { name = "git" },
                { name = "buffer" },
            },
        })
    end,
}
