return {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
        auto_resize_height = true,
        preview = {
            winblend = 0,
        },
        border = require("rizhiy.border").Border(),
        show_scroll_bar = false,
        delay_syntax = 0,
        func_map = {
            vsplit = "v",
            split = "-",
        },
    },
}
