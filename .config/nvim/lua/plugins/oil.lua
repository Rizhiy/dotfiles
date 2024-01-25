return {
    "stevearc/oil.nvim",
    opts = {
        keymaps = {
            ["?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["v"] = "actions.select_vsplit",
            ["-"] = "actions.select_split",
            ["<C-t>"] = "actions.select_tab",
            ["<C-p>"] = "actions.preview",
            ["<C-d>"] = "actions.close",
            ["<C-r>"] = "actions.refresh",
            ["<BS>"] = "actions.parent",
            ["~"] = "actions.open_cwd",
            ["gs"] = "actions.change_sort",
            ["gx"] = "actions.open_external",
            ["g."] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = true,
        columns = {
            "mtime",
            "size",
            "icon",
        },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "-", ":Oil<CR>", desc = "Open parent directory" },
    },
}
