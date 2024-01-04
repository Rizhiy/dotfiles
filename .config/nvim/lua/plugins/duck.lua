return {
    "tamton-aquib/duck.nvim",
    keys = {
        { "<leader>od", function() require("duck").hatch() end, desc = "Release the duck" },
        { "<leader>oc", function() require("duck").cook() end, desc = "Catch the duck" },
    },
}
