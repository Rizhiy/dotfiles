function keymap(lhs, rhs, desc) return { lhs, rhs, desc = desc, mode = { "n", "v", "i", "x" }, silent = true } end

return {
    {
        "christoomey/vim-tmux-navigator",
        keys = {
            keymap("<M-h>", "<ESC>:<C-U>TmuxNavigateLeft<CR>", "Move Left"),
            keymap("<M-j>", "<ESC>:<C-U>TmuxNavigateDown<CR>", "Move Down"),
            keymap("<M-k>", "<ESC>:<C-U>TmuxNavigateUp<CR>", "Move Up"),
            keymap("<M-l>", "<ESC>:<C-U>TmuxNavigateRight<CR>", "Move Right"),
        },
        init = function()
            vim.cmd("let g:tmux_navigator_save_on_switch = 2") -- Write all buffers before navigating from Vim to tmux pane
        end,
    },
    { "tmux-plugins/vim-tmux" },
}
