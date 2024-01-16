vim.opt.termguicolors = true

vim.opt.cursorline = true
vim.opt.laststatus = 2

vim.opt.showtabline = 0 -- Never show tabline
vim.opt.conceallevel = 0 -- Don't hide links and stuff in Markdown

vim.opt.iskeyword = vim.opt.iskeyword + "-" -- treat dash-separated words as whole word objects

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.formatoptions:remove({ "c", "r", "o" })

vim.opt.list = true
vim.opt.listchars:append({ tab = "▸ ", trail = "·" }) -- show empty characters tab/eol
vim.opt.fillchars:append({ vert = " " })

vim.opt.signcolumn = "auto:1-2"

vim.opt.scrolloff = 5

local autocmd = vim.api.nvim_create_autocmd
local mild_color = "DimGray"
autocmd({ "ColorScheme" }, {
    callback = function(_)
        vim.cmd("hi NormalFloat guibg=None")
        vim.cmd("hi FloatBorder guibg=None guifg=" .. mild_color)
        for _, name in ipairs({
            "FloatermBorder",
            "CmpDocBorder",
            "TelescopePromptBorder",
            "TelescopePreviewBorder",
            "TelescopeResultsBorder",
            "TreesitterContextSeparator",
        }) do
            vim.api.nvim_set_hl(0, name, { link = "FloatBorder" })
        end

        vim.cmd("hi WinSeparator guifg=bg guibg=bg")
        vim.cmd("hi DapBreakpointSymbol guibg=None")
        vim.cmd("hi DapStoppedSymbol guibg=None")
        vim.cmd("hi CursorLine gui=underline guibg=None guisp=" .. mild_color)
    end,
})
