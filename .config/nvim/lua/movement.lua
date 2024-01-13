local nmap = require("rizhiy.keys").nmap
nmap("gb", "<C-o>", { desc = "Go to previous location", noremap = true })
nmap("gf", "<C-i>", { desc = "Go to next location", noremap = true })

nmap("<C-j>", "<C-e>j", { desc = "Move screen down" })
nmap("<C-k>", "<C-y>k", { desc = "Move screen up" })

for idx = 1, 9 do
    nmap("<leader>" .. idx, idx .. "<C-w>w", { desc = "Move to window " .. idx })
end
