return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
        "s1n7ax/nvim-window-picker",
    },
    keys = {
        {
            "<leader>e",
            function() require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() }) end,
            desc = "File Explorer",
        },
    },
    opts = {
        popup_border_style = require("rizhiy.border").Border(),
        window = {
            position = "float",
            mappings = {
                ["<cr>"] = "open_with_window_picker",
                ["v"] = "open_vsplit",
                ["-"] = "open_split",
                ["."] = "toggle_hidden",
                ["h"] = function(state)
                    local node = state.tree:get_node()
                    if node.type == "file" then node = state.tree:get_node(node:get_parent_id()) end
                    require("neo-tree.sources.filesystem").toggle_directory(state, node)
                end,
                ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            },
        },
    },
}
