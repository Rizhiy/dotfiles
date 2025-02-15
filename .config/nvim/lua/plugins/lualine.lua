local function window() return vim.api.nvim_win_get_number(0) end
local diff_component = {
    function() return "DIFF" end,
    cond = function() return vim.wo.diff end,
    color = { bg = "red" },
}
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { { "nvim-tree/nvim-web-devicons", opt = true }, "folke/noice.nvim" },
    event = "BufEnter",
    config = function()
        local noice = require("noice")
        local filename_component = {
            -- filename relative to cwd
            "filename",
            path = 1,
        }
        require("lualine").setup({
            sections = {
                lualine_a = {
                    "mode",
                    diff_component,
                },
                lualine_c = {
                    filename_component,
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
                    {
                        "encoding",
                        cond = function()
                            local ret, _ = vim.bo.fenc:gsub("^utf%-8$", "")
                            return ret
                        end,
                    },
                    {
                        "fileformat",
                        cond = function()
                            local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
                            return ret
                        end,
                    },
                    "filetype",
                },
            },
            inactive_sections = {
                lualine_a = {
                    diff_component,
                },
                lualine_c = {
                    filename_component,
                },
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
