vim.opt.cursorline = true

vim.opt.showtabline = 0 -- Never show tabline
vim.opt.cmdheight = 2 -- More space for messages
vim.opt.conceallevel = 0 -- Don't hide links and stuff in Markdown

vim.opt.iskeyword = vim.opt.iskeyword + "-" -- treat dash-separated words as whole word objects

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.formatoptions:remove({"c","r","o"})

vim.opt.list = true
vim.opt.listchars:append({tab = "▸ ", trail = "·"}) -- show empty characters tab/eol

vim.opt.signcolumn = "auto:2"

vim.opt.scrolloff = 5
