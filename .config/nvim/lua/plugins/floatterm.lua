return {
    "voldikss/vim-floaterm",
    keys = {
        { "<F1>",      "<ESC>:FloatermToggle<CR>", mode = { "n", "v", "i" }, desc = "Toggle terminal" },
        { "<F2>",      "<ESC>:FloatermPrev<CR>",   mode = { "n", "v", "i" }, desc = "Prev terminal" },
        { "<F3>",      "<ESC>:FloatermNext<CR>",   mode = { "n", "v", "i" }, desc = "Next terminal" },
        { "<F4>",      "<ESC>:FloatermNew<CR>",    mode = { "n", "v", "i" }, desc = "New terminal" },
        { "<leader>g", ":FloatermNew lazygit<CR>", desc = "LazyGit" },
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
}
