vim.opt.fileencoding="utf-8"

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.timeoutlen=300

vim.opt.spell = true
vim.opt.spelllang = "en_gb,en_us"
vim.opt.spellfile = vim.fn.stdpath("data") .. "/spell/words.add"

vim.opt.swapfile = false
vim.opt.autowrite = true
vim.opt.autowriteall = true

vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 1
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = ' '

local autocmd = vim.api.nvim_create_autocmd
autocmd(
    {"BufEnter"},
    {
        pattern = "*",
        callback = function(_)
            vim.opt.formatoptions:remove({"c", "r", "o"})
        end
    }
)
-- Is this required with autoread?
autocmd(
    {"BufEnter", "FocusGained"},
    {
        pattern = "*",
        callback = function(_)
            vim.cmd("checktime")
        end
    }
)
