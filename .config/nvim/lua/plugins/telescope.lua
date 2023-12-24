return {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-ui-select.nvim" },
    },
    keys = {
        { "<leader>f", "<cmd>lua FuzzyFindFiles{}<CR>", desc = "Fuzzy search" },
        -- TODO: Fix this to search hidden files AND respect .gitignore
        { "<leader>ff", ":Telescope find_files hidden=true<CR>", desc = "Search files" },
        { "<leader>fe", ":Telescope live_grep<CR>", desc = "Exact search" },
        { "<leader>fb", ":Telescope buffers<CR>", desc = "Search buffers" },
        { "<leader>fh", ":Telescope help_tags<CR>", desc = "Search tags" },
        { "<leader>fk", ":Telescope keymaps<CR>", desc = "Search keys" },
        { "<leader>fd", ":Telescope diagnostics<CR>", desc = "Search diagnostics" },
        { "<leader>gc", ":Telescope git_bcommits<CR>", desc = "Show commit history for this buffer" },
        { "<leader>gb", ":Telescope git_branches<CR>", desc = "Show all available branches" },
    },
    config = function()
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("ui-select")
        local builtin = require("telescope.builtin")
        function FuzzyFindFiles()
            -- TODO: .gitignore here as well
            -- https://github.com/nvim-telescope/telescope.nvim/issues/2780
            builtin.grep_string({
                path_display = { "smart" },
                only_sort_text = true,
                word_match = "-w",
                search = "",
                additional_args = { "--hidden" },
            })
        end

        local actions = require("telescope.actions")
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
        })
    end,
}
