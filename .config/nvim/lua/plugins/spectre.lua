return {
    "nvim-pack/nvim-spectre",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>fs", '<cmd>lua require("spectre").toggle()<CR>', desc = "Global search and replace" },
    },
}
