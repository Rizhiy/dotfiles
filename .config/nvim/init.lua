local version = vim.version()
if version.major == 0 and vim.version().minor < 10 then
    error("Unsupported neovim version, should be at least 0.10")
    return
end

require("general")
require("appearance")
require("mappings")
require("movement")
require("filetypes")

require("rizhiy.lazy")
require("rizhiy.autorooter")
