return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        local work_dir = vim.loop.cwd()
        local opts = {
            settings = { save_on_toggle = true, sync_on_ui_close = true, key = function() return work_dir end },
        }
        opts[require("harpoon.config").DEFAULT_LIST] = {
            create_list_item = function(_, item)
                if item == nil then item = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) end

                if type(item) == "string" then
                    local name = require("plenary.path"):new(item):make_relative(work_dir)
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

        local nmap = require("rizhiy.keys").nmap

        nmap("<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open harpoon list" })
        nmap("<leader>ha", function() harpoon:list():append() end, { desc = "Add to harpoon" })
        nmap("<leader>hr", function() harpoon:list():remove() end, { desc = "Remove from harpoon" })

        for idx = 1, 9 do
            nmap("<leader>h" .. idx, function() harpoon:list():select(idx) end, { desc = "Go to harpoon " .. idx })
        end

        nmap("<leader>hp", function() harpoon:list():prev() end, { desc = "Go to prev harpoon" })
        nmap("<leader>hn", function() harpoon:list():next() end, { desc = "Go to next harpoon" })

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
