return {
    "leath-dub/snipe.nvim",
    keys = {
        {
            "gb",
            function() require("snipe").create_buffer_menu_toggler()() end,
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
