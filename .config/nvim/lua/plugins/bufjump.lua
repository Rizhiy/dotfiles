return {
    "kwkarlwang/bufjump.nvim",
    keys = {
        { "]b", function() require("bufjump").forward() end,  desc = "Go to next buffer",     silent = true },
        { "[b", function() require("bufjump").backward() end, desc = "Go to previous buffer", silent = true },
    },
    opts = true,
}
