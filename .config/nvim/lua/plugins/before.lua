return {
    "bloznelis/before.nvim",
    opts = {},
    keys = {
        { "gb", function() require("before").jump_to_last_edit() end, desc = "Go back to last edit" },
        { "gf", function() require("before").jump_to_next_edit() end, desc = "Go forward to next edit" },
    },
}
