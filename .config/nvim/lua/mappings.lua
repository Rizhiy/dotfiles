vim.g.mapleader = " "

local map = require("rizhiy.keys").map
local nmap = require("rizhiy.keys").nmap

map("q:", "<nop>", { desc = "Disable command history" })
map("<C-c>", "<ESC>", { desc = "Escape" })

map("<ESC>", ":noh<CR>", { desc = "Deselect search highlight" })
map("<leader>a", "za", { desc = "Toggle fold" })
map("<leader>A", "zA", { desc = "Open all folds under cursor" })
map("<leader>R", "zR", { desc = "Open all folds" })
map("<leader>y", function()
    -- This is *start* and *end* of selection, will be first or last line depending on whether you selected up or down
    local v_start = vim.fn.getpos("v")[2]
    local v_end = vim.fn.getpos(".")[2]

    local selected = vim.api.nvim_buf_get_lines(0, math.min(v_start, v_end) - 1, math.max(v_start, v_end), true)

    local indent = require("rizhiy.utils").get_indent(selected)
    for i, line in ipairs(selected) do
        selected[i] = line:sub(indent)
    end

    local text = table.concat(selected, "\n")
    vim.fn.setreg("+", text)
    require("rizhiy.keys").press("<ESC>", "n")
end, { desc = "Copy to system clipboard", mode = "v" })

-- Move selection
map("J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", mode = "v" })
map("K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", mode = "v" })
map("<", "<gv", { desc = "Un-indent selection", mode = "v" })
map(">", ">gv", { desc = "Indent selection", mode = "v" })

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
nmap("<C-q>", ":qall<CR>", { desc = "Exit" })

nmap("J", "mzJ`z", { desc = "Append line below to current line" })

map("p", '"_dP', { desc = "Paste over without yanking", mode = "x" })

-- Replace in selection
map(":s", ":s/\\%V\\%V/<Left><Left><Left><Left>", { desc = "Replace in selection", mode = "v" })

-- Toggle virtualedit
map("<leader>ov", function()
    local current_value = vim.opt.virtualedit
    if current_value == "all" then
        vim.opt.virtualedit = ""
    else
        vim.opt.virtualedit = "all"
    end
end, { desc = "Toggle virtualedit" })
