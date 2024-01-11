return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({ settings = { save_on_toggle = true, sync_on_ui_close = true } })

        local nmap = require("rizhiy.keys").nmap

        nmap("<leader>ha", function() harpoon:list():append() end, { desc = "Add to harpoon" })

        nmap("<leader>h1", function() harpoon:list():select(1) end, { desc = "Go to harpoon 1" })
        nmap("<leader>h2", function() harpoon:list():select(2) end, { desc = "Go to harpoon 2" })
        nmap("<leader>h3", function() harpoon:list():select(3) end, { desc = "Go to harpoon 3" })
        nmap("<leader>h4", function() harpoon:list():select(4) end, { desc = "Go to harpoon 4" })

        nmap("<leader>hp", function() harpoon:list():prev() end, { desc = "Go to prev harpoon" })
        nmap("<leader>hn", function() harpoon:list():next() end, { desc = "Go to next harpoon" })
        nmap("<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open harpoon list" })

        -- basic telescope configuration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                })
                :find()
        end

        nmap("<leader>fh", function() toggle_telescope(harpoon:list()) end, { desc = "Search harpoon" })
    end,
}
