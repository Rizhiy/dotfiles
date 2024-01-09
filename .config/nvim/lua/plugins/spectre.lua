return {
    "nvim-pack/nvim-spectre",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>fg", function() require("spectre").toggle() end, desc = "Global search and replace" },
    },
}
