return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
        's1n7ax/nvim-window-picker',
    },
    keys = {
        {
            "<leader>e", 
            function()
                require("neo-tree.command").execute({toggle=true,dir=vim.loop.cwd()})
            end,
            desc = "File Explorer"},
    },
    opts = {
        window = {
            position = "float",
            mappings = {
                ["<cr>"] = "open_with_window_picker",
                ["v"] = "open_vsplit",
                ["h"] = "open_split",
                ["."] = "toggle_hidden",
            }
        }
    }
}
