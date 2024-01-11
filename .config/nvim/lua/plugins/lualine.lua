local function window() return vim.api.nvim_win_get_number(0) end
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    opts = {
        inactive_sections = {
            lualine_y = { window },
        },
        options = {
            theme = "gruvbox-material",
        },
    },
}
