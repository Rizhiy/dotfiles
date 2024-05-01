return {
    "tamton-aquib/duck.nvim",
    keys = {
        { "<leader>oD", function() require("duck").hatch() end, desc = "Release the duck" },
        { "<leader>oC", function() require("duck").cook() end,  desc = "Catch the duck" },
    },
}
