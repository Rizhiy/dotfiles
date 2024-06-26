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
            b = { name = "Buffer" },
            c = { name = "Code" },
            d = { name = "Debugging" },
            f = { name = "Find" },
            h = { name = "Harpoon" },
            m = { name = "Markdown" },
            r = { name = "Run" },
            o = { name = "Other" },
            s = { name = "ScratchPad" },
            g = { name = "Git", h = { name = "GitHub" } },
            x = { name = "Snippets" },
        }, { prefix = "<leader>" })
    end,
}
