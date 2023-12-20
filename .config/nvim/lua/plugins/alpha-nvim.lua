return {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        local startify = require("alpha.themes.startify")
        
        startify.section.bottom_buttons.val = {
            startify.file_button(vim.fn.stdpath("config") .. "/init.lua", "C"),
            startify.file_button("~/.zshrc", "Z"),
            startify.button("q", "Quit", "<cmd>q <CR>"), -- preserve the quit button
        }

        win_width = vim.api.nvim_win_get_width(0)
        logo_width = 54 -- roughly
        startify.config.opts.margin = math.floor((win_width - logo_width) / 2)
        require("alpha").setup(startify.config)
    end
}
