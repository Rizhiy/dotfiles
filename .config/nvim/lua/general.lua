vim.opt.fileencoding = "utf-8"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.spell = true
vim.opt.spelllang = "en_gb,en_us"
vim.opt.spellfile = vim.fn.stdpath("data") .. "/spell/words.add"

vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 300

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.foldmethod = "indent"
vim.opt.foldopen:append("jump")
vim.opt.foldlevel = 10

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep undo across sessions
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Better wrapping
vim.opt.breakindent = true

-- Allow selecting past the end of the line in visual mode
vim.opt.virtualedit = "block"

local autocmd = vim.api.nvim_create_autocmd
autocmd({ "BufEnter" }, {
    callback = function(_) vim.opt.formatoptions:remove({ "c", "r", "o" }) end,
})

-- Python for general functions
vim.cmd("let g:python3_host_prog = '" .. os.getenv("HOME") .. "/miniconda3/bin/python'")

-- Set filetype to htmldjango for jinja
vim.filetype.add({ pattern = { [".*.html.jinja"] = "htmldjango" } })
