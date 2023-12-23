vim.g.mapleader = " "

vim.keymap.set("", "q:", "<nop>")

vim.keymap.set("", "  ", ":noh<CR>", { desc = "Deselect search highlight" })
vim.keymap.set("", "<leader>a", "za", { desc = "Toggle fold" })
vim.keymap.set("", "<leader>A", "zA", { desc = "Open all folds" })

-- Move selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "H", "<gv", { desc = "Un-indent selection" })
vim.keymap.set("v", "L", ">gv", { desc = "Indent selection" })

vim.keymap.set("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>h", ":split<CR>", { desc = "Horisontal Split" })

-- Split resize
vim.keymap.set("n", "<C-Left>", ":vertical resize +3<CR>", { desc = "Increase vertical split size" })
vim.keymap.set("n", "<C-Right>", ":vertical resize -3<CR>", { desc = "Decrease vertical split size" })
vim.keymap.set("n", "<C-Up>", ":resize +3<CR>", { desc = "Increase split size" })
vim.keymap.set("n", "<C-Down>", ":resize -3<CR>", { desc = "Decrease split size" })

-- Don't overwrite yanked content on delete and change
vim.keymap.set("n", "d", '"_d', { desc = "Delete" })
vim.keymap.set("n", "c", '"_c', { desc = "Change" })
vim.keymap.set("n", "x", "d", { desc = "Cut" })

vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<C-d>", ":q<CR>", { desc = "Close pane", silent = true })

vim.keymap.set("", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
