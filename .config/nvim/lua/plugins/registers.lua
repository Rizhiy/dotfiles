return {
    "tversteeg/registers.nvim",
    name = "registers",
    keys = {
        { '"',     mode = { "n", "v" } },
        { "<C-R>", mode = "i" },
    },
    cmd = "Registers",
    opts = {
        window = {
            border = require("rizhiy.border").Border(),
            transparency = 0,
        },
    },
}
