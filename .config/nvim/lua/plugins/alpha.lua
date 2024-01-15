--- @param session string
local function session2project(session) return session:match("[^%%]*$"):sub(1, -5) end

return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/persistence.nvim" },
    config = function()
        local startify = require("alpha.themes.startify")

        local persistence = require("persistence")

        local top_buttons = {
            startify.button("e", "New file", "<cmd>ene <CR>"), -- preserver original file edit
            { type = "padding", val = 1 },
        }
        local current_session = persistence.get_current()
        if current_session then
            table.insert(
                top_buttons,
                startify.button(
                    "S",
                    string.format("Project Session (%s)", session2project(current_session)),
                    ":lua require('persistence').load()<CR>"
                )
            )
        end
        local last_session = persistence.get_last()
        if last_session and last_session ~= current_session then
            table.insert(
                top_buttons,
                startify.button(
                    "L",
                    string.format("Last Global Session (%s)", session2project(last_session)),
                    ":lua require('persistence').load({last = true})<CR>"
                )
            )
        end
        startify.section.top_buttons.val = top_buttons

        startify.section.bottom_buttons.val = {
            startify.file_button(vim.fn.stdpath("config") .. "/init.lua", "C"),
            startify.file_button("~/.zshrc", "Z"),
            { type = "padding", val = 1 },
            startify.button("M", "Messages", ":messages<CR>"),
            { type = "padding", val = 1 },
            startify.button("q", "Quit", ":q<CR>"), -- preserve the quit button
        }

        local win_width = vim.api.nvim_win_get_width(0)
        local logo_width = 54 -- roughly
        startify.config.opts.margin = math.floor((win_width - logo_width) / 2)
        require("alpha").setup(startify.config)
    end,
}
