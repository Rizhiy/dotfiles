return {
    "tversteeg/registers.nvim",
    keys = {
        { '"', mode = { "n", "v" } },
        { "<C-R>", mode = "i" },
    },
    cmd = "Registers",
    config = function()
        local registers = require("registers")
        registers.setup({
            window = {
                border = require("rizhiy.border").Border(),
                transparency = 0,
            },
            bind_keys = {
                registers = registers.apply_register({ keep_open_until_keypress = true }),
            },
        })
    end,
}
