local home = vim.fn.expand("$HOME")
local config_dir = home .. "/.config"

vim.filetype.add({ pattern = { [config_dir .. "/sway/.*.conf"] = "swayconfig" } })
vim.filetype.add({ pattern = { [".*.html.jinja"] = "htmldjango" } })
