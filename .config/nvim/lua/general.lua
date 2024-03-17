vim.opt.fileencoding = "utf-8"

-- NOTE: Maybe use 'tpope/vim-sleuth'?
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

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

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep undo across sessions
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Better wrapping
vim.opt.breakindent = true

local autocmd = vim.api.nvim_create_autocmd
autocmd({ "BufEnter" }, {
    callback = function(_) vim.opt.formatoptions:remove({ "c", "r", "o" }) end,
})

autocmd({ "BufReadPost" }, {
    callback = function(_)
        if vim.api.nvim_buf_line_count(0) > 120 then
            vim.opt.foldlevel = 1
        else
            vim.opt.foldlevel = 10
        end
    end,
})

-- Python for general functions
vim.cmd("let g:python3_host_prog = '" .. os.getenv("HOME") .. "/miniconda3/bin/python'")
