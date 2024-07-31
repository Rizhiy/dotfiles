return {
    "leath-dub/snipe.nvim",
    keys = {
        {
            "gb",
            function() require("snipe").open_buffer_menu() end,
            desc = "Snipe a buffer",
        },
    },
    opts = {
        navigate = {
            next_page = "<C-j>",
            prev_page = "<C-k>",
        },
        ui = {
            position = "cursor",
        },
    },
}
