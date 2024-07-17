vim.g.mapleader = " "

local map = require("rizhiy.keys").map
local nmap = require("rizhiy.keys").nmap

map("q:", "<nop>", { desc = "Disable command history" })
map("<C-c>", "<ESC>", { desc = "Escape" })
map("<leader>e", ":e!<CR>", { desc = "Force reload current file" })

map("<ESC>", ":noh<CR>", { desc = "Deselect search highlight" })
map("<leader>a", "za", { desc = "Toggle fold" })
map("<leader>A", "zA", { desc = "Open all folds under cursor" })
map("<leader>R", "zR", { desc = "Open all folds" })
map("<leader>y", function()
    -- This is *start* and *end* of selection, will be first or last line depending on whether you selected up or down
    local v_start = vim.fn.getpos("v")[2]
    local v_end = vim.fn.getpos(".")[2]
    local first_line = math.min(v_start, v_end)
    local last_line = math.max(v_start, v_end)

    -- if text is on one line, just get the selection
    if first_line == last_line then
        require("rizhiy.keys").press('"+y', "n")
        return
    end

    local selected = vim.api.nvim_buf_get_lines(0, first_line - 1, last_line, true)

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
nmap("<leader>-", ":split<CR>", { desc = "Horizontal Split", silent = true })

-- Split resize
nmap("<C-Left>", ":vertical resize +3<CR>", { desc = "Increase vertical split size" })
nmap("<C-Right>", ":vertical resize -3<CR>", { desc = "Decrease vertical split size" })
nmap("<C-Up>", ":resize +3<CR>", { desc = "Increase split size" })
nmap("<C-Down>", ":resize -3<CR>", { desc = "Decrease split size" })

-- Don't overwrite yanked content on delete and change
map("d", '"_d', { desc = "Delete" })
map("c", '"_c', { desc = "Change" })
map("x", "d", { desc = "Cut" })
nmap("dd", 'V"_d', { desc = "Delete line" })

nmap("<C-s>", ":w<CR>", { desc = "Save buffer" })
nmap("<C-d>", ":q<CR>", { desc = "Close pane", silent = true })
nmap("<C-q>", function()
    pcall(vim.cmd.ccl)
    pcall(vim.cmd.DiffviewClose)
    pcall(require("neotest").summary.close)
    vim.cmd.qall()
end, { desc = "Exit" })

nmap("J", "mzJ`z", { desc = "Append line below to current line" })

map("p", '"_dP', { desc = "Paste over without yanking", mode = "x" })

-- Toggle virtualedit
map("<leader>ov", function()
    local current_value = vim.opt.virtualedit
    if current_value == "all" then
        vim.opt.virtualedit = ""
    else
        vim.opt.virtualedit = "all"
    end
end, { desc = "Toggle virtualedit" })

nmap(
    "th",
    function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
    { desc = "Toggle inlay hints" }
)

nmap("<leader>bd", function()
    local win_id = vim.api.nvim_get_current_win()
    local toggled = vim.wo[win_id][0].diff
    vim.wo[win_id][0].diff = not toggled
    vim.wo[win_id][0].scrollbind = not toggled
    vim.wo[win_id][0].foldlevel = toggled and 10 or 0
    vim.wo[win_id][0].foldmethod = toggled and "indent" or "diff"
end, { desc = "Toggle diff mode for window" })

-- Lazy
nmap("<leader>lu", function()
    vim.notify("Running lazy update")
    require("lazy").update({ show = false })
end, { desc = "Update plugins" })
nmap("<leader>lc", function()
    require("lazy").clean({ show = false })
    vim.notify("Running lazy clean")
end, { desc = "Clean plugins" })

-- Quickfix
nmap("<leader>q", ":copen<CR>", { desc = "Open quickfix" })
nmap("]q", ":cnext<CR>", { desc = "Next item in quickfix" })
nmap("[q", ":cprev<CR>", { desc = "Prev item in quickfix" })
