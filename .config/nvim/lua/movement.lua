local nmap = require("rizhiy.keys").nmap
nmap("gb", "<C-o>", { desc = "Go to previous location", noremap = true })
nmap("gf", "<C-i>", { desc = "Go to next location", noremap = true })
