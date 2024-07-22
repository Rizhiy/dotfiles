return {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            "<leader>hl",
            function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
            desc = "Open harpoon list",
        },
        { "<leader>ha", function() require("harpoon"):list():add() end,            desc = "Add to harpoon" },
        { "<leader>hr", function() require("harpoon"):list():remove() end,         desc = "Remove from harpoon" },
        { "<leader>hp", function() require("harpoon"):list():prev() end,           desc = "Go to prev harpoon" },
        { "<leader>hn", function() require("harpoon"):list():next() end,           desc = "Go to next harpoon" },
        { "<leader>hs", function() ToggleTelescope(require("harpoon"):list()) end, desc = "Search harpoon" },
    },
    config = function()
        local harpoon = require("harpoon")

        local opts = {
            settings = { save_on_toggle = true, sync_on_ui_close = true, key = function() return "global" end },
        }
        opts[require("harpoon.config").DEFAULT_LIST] = {
            create_list_item = function(_, item)
                if item == nil then item = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) end

                if type(item) == "string" then
                    local name = require("plenary.path"):new(item):absolute()
                    local bufnr = vim.fn.bufnr(name, false)

                    local pos = { 1, 0 }
                    if bufnr ~= -1 then pos = vim.api.nvim_win_get_cursor(0) end
                    item = {
                        value = name,
                        context = {
                            row = pos[1],
                            col = pos[2],
                        },
                    }
                end
                return item
            end,
        }
        harpoon:setup(opts)

        for idx = 1, 9 do
            require("rizhiy.keys").nmap(
                "<leader>h" .. idx,
                function() harpoon:list():select(idx) end,
                { desc = "Go to harpoon " .. idx }
            )
        end

        -- basic telescope configuration
        local conf = require("telescope.config").values
        function ToggleTelescope(harpoon_files)
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
    end,
}
