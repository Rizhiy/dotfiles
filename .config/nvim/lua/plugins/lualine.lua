local function window() return vim.api.nvim_win_get_number(0) end
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { { "nvim-tree/nvim-web-devicons", opt = true }, "folke/noice.nvim" },
    event = "BufEnter",
    config = function()
        local noice = require("noice")
        require("lualine").setup({
            sections = {
                lualine_c = {
                    { -- filename relative to cwd
                        "filename",
                        path = 1,
                    },
                    { -- search count
                        noice.api.status.search.get,
                        cond = require("noice").api.status.search.has,
                        color = { fg = "#ff9e64" },
                    },
                },
                lualine_x = {
                    { -- Show when macro is being recorded
                        noice.api.statusline.mode.get,
                        cond = noice.api.statusline.mode.has,
                        color = { fg = "#ff9e64" },
                    },
                    -- Original sections
                    "encoding",
                    "fileformat",
                    "filetype",
                },
            },
            inactive_sections = {
                lualine_y = { window },
            },
            options = {
                theme = "gruvbox-material",
                disabled_filetypes = {
                    statusline = {
                        "alpha",
                    },
                },
            },
            tabline = { lualine_a = { { "tabs", mode = 2, path = 1 } } },
            extensions = {
                "mason",
                "lazy",
                "quickfix",
                "trouble",
            },
        })
        vim.cmd("set showtabline=1")
    end,
}
