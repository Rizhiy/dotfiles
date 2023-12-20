return {
    'voldikss/vim-floaterm',
    keys = {
        {"<F1>", "<ESC>:FloatermToggle<CR>", mode={"i", "n", "v"}},
        {"<leader>g", ":FloatermNew! lazygit<CR>", desc = "LazyGit"}
    },
    lazy = false,
    init = function ()
        vim.cmd("let g:floaterm_keymap_toggle = '<F1>'")
        vim.cmd("let g:floaterm_keymap_prev   = '<F2>'")
        vim.cmd("let g:floaterm_keymap_next   = '<F3>'")
        vim.cmd("let g:floaterm_keymap_new    = '<F4>'")
        vim.cmd("let g:floaterm_width=0.9")
        vim.cmd("let g:floaterm_height=0.9")
        vim.cmd("let g:floaterm_wintitle=0")
    end
}
