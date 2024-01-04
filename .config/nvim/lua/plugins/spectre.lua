return {
    "nvim-pack/nvim-spectre",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>fs", function() require("spectre").toggle() end, desc = "Global search and replace" },
    },
}
