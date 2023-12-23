return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({})

        local nmap = require("rizhiy.keys").nmap

        nmap("<leader>ha", function() harpoon:list():append() end, { desc = "Add to harpoon" })
        nmap(
            "<leader>hl",
            function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Open harpoon quick-menu" }
        )

        nmap("<leader>1", function() harpoon:list():select(1) end, { desc = "Go to harpoon 1" })
        nmap("<leader>2", function() harpoon:list():select(2) end, { desc = "Go to harpoon 2" })
        nmap("<leader>3", function() harpoon:list():select(3) end, { desc = "Go to harpoon 3" })
        nmap("<leader>4", function() harpoon:list():select(4) end, { desc = "Go to harpoon 4" })

        nmap("<leader>hp", function() harpoon:list():prev() end, { desc = "Go to prev harpoon" })
        nmap("<leader>hn", function() harpoon:list():next() end, { desc = "Go to next harpoon" })
    end,
}
