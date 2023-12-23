return {
    "christoomey/vim-tmux-navigator",
    keys = {
        { "<M-h>", ":<C-U>TmuxNavigateLeft<CR>", desc = "Move Left", silent = true },
        { "<M-j>", ":<C-U>TmuxNavigateDown<CR>", desc = "Move Down", silent = true },
        { "<M-k>", ":<C-U>TmuxNavigateUp<CR>", desc = "Move Up", silent = true },
        { "<M-l>", ":<C-U>TmuxNavigateRight<CR>", desc = "Move Right", silent = true },
        { "<M-\\>", ":<C-U>TmuxNavigateDown<CR>", desc = "Move Down", silent = true },
    },
    init = function()
        vim.cmd("let g:tmux_navigator_save_on_switch = 2") -- Write all buffers before navigating from Vim to tmux pane
    end,
}
