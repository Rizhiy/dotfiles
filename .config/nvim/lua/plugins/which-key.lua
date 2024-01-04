return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.register({
            g = { name = "Go" },
            z = { name = "Folds" },
        })
        wk.register({
            c = { name = "Code" },
            d = { name = "Debugging" },
            f = { name = "Find" },
            h = { name = "Harpoon" },
            m = { name = "Markdown" },
            r = { name = "Run" },
            o = { name = "Other" },
        }, { prefix = "<leader>" })
    end,
}
