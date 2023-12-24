vim.g.mapleader = " "

local map = require("rizhiy.keys").map
local nmap = require("rizhiy.keys").nmap

map("q:", "<nop>", { desc = "Disable command history" })
map("<C-c>", "<ESC>", { desc = "Escape" })

map("  ", ":noh<CR>", { desc = "Deselect search highlight" })
map("<leader>a", "za", { desc = "Toggle fold" })
map("<leader>A", "zA", { desc = "Open all folds" })
map("<leader>y", '"+y', { desc = "Copy to system clipboard", mode = "v" })

-- Move selection
map("J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", mode = "v" })
map("K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", mode = "v" })
map("H", "<gv", { desc = "Un-indent selection", mode = "v" })
map("L", ">gv", { desc = "Indent selection", mode = "v" })

nmap("<leader>v", ":vsplit<CR>", { desc = "Vertical Split", silent = true })
nmap("<leader>-", ":split<CR>", { desc = "Horisontal Split", silent = true })

-- Split resize
nmap("<C-Left>", ":vertical resize +3<CR>", { desc = "Increase vertical split size" })
nmap("<C-Right>", ":vertical resize -3<CR>", { desc = "Decrease vertical split size" })
nmap("<C-Up>", ":resize +3<CR>", { desc = "Increase split size" })
nmap("<C-Down>", ":resize -3<CR>", { desc = "Decrease split size" })

-- Don't overwrite yanked content on delete and change
nmap("d", '"_d', { desc = "Delete" })
nmap("c", '"_c', { desc = "Change" })
nmap("x", "d", { desc = "Cut" })

nmap("<C-s>", ":w<CR>", { desc = "Save buffer" })
nmap("<C-d>", ":q<CR>", { desc = "Close pane", silent = true })

nmap("J", "mzJ`z", { desc = "Append line below to current line" })
