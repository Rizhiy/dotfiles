local nmap = require("rizhiy.keys").nmap

nmap("<C-j>", "<C-e>j", { desc = "Move screen down" })
nmap("<C-k>", "<C-y>k", { desc = "Move screen up" })

nmap("<left>", ':echo "Use h to move!!"<CR>', { desc = "<Disabled>" })
nmap("<right>", ':echo "Use l to move!!"<CR>', { desc = "<Disabled>" })
nmap("<up>", ':echo "Use k to move!!"<CR>', { desc = "<Disabled>" })
nmap("<down>", ':echo "Use j to move!!"<CR>', { desc = "<Disabled>" })

for idx = 1, 9 do
    nmap("<leader>" .. idx, idx .. "<C-w>w", { desc = "Move to window " .. idx })
end

-- Extra movement
local brackets = "[]{}<>()"
for bracket in brackets:gmatch(".") do
    nmap("]" .. bracket, ":call search('" .. bracket .. "')<CR>", { desc = "Next " .. bracket })
    nmap("[" .. bracket, ":call search('" .. bracket .. "', 'b')<CR>", { desc = "Previous " .. bracket })
end
nmap("]q", ":cnext<CR>", { desc = "Next item in quickfix" })
nmap("[q", ":cprev<CR>", { desc = "Previous item in quickfix" })
