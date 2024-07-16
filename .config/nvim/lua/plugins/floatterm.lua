return {
    {
        "voldikss/vim-floaterm",
        keys = {
            { "<F1>",  "<ESC>:FloatermToggle<CR>", mode = { "n", "v", "i" }, desc = "Toggle terminal",           silent = true },
            { "<F2>",  "<ESC>:FloatermPrev<CR>",   mode = { "n", "v", "i" }, desc = "Prev terminal",             silent = true },
            { "<F3>",  "<ESC>:FloatermNext<CR>",   mode = { "n", "v", "i" }, desc = "Next terminal",             silent = true },
            { "<F4>",  "<ESC>:FloatermNew<CR>",    mode = { "n", "v", "i" }, desc = "New terminal",              silent = true },
            { "<ESC>", "<C-\\><C-N>",              mode = "t",               desc = "Make ESC work in terminal", silent = true },
        },
        init = function()
            vim.cmd("let g:floaterm_keymap_toggle = '<F1>'")
            vim.cmd("let g:floaterm_keymap_prev   = '<F2>'")
            vim.cmd("let g:floaterm_keymap_next   = '<F3>'")
            vim.cmd("let g:floaterm_keymap_new    = '<F4>'")
            vim.cmd("let g:floaterm_width=0.9")
            vim.cmd("let g:floaterm_height=0.9")
            vim.cmd("let g:floaterm_wintitle=0")
        end,
    },
    {
        -- Installing second toggleterm for application specific terminals
        "akinsho/toggleterm.nvim",
        keys = {
            { "<leader>g", function() LazyGit:toggle() end },
        },
        config = function()
            require("toggleterm").setup({
                direction = "float",
                float_opts = {
                    border = require("rizhiy.border").Border(),
                },
                highlights = {
                    FloatBorder = { link = "CmpDocBorder" },
                },
            })
            local Terminal = require("toggleterm.terminal").Terminal
            LazyGit = Terminal:new({
                cmd = "lazygit",
                hidden = true,
            })

            local map = require("rizhiy.keys").map
            local autocmd = vim.api.nvim_create_autocmd
            autocmd({ "TermOpen" }, {
                pattern = "term://*toggleterm#*",
                callback = function()
                    local exit_keymap = [[<C-\>q]]
                    map("<ESC>", exit_keymap, { mode = { "t" } })
                    map("<leader>g", exit_keymap, { mode = { "t" } })
                end,
            })
        end,
    },
}
