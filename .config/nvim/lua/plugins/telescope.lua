return {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-ui-select.nvim",
        { "stevearc/aerial.nvim",                     opts = {} },
    },
    keys = {
        { "<leader>f",  function() FuzzyFindFiles() end, desc = "Fuzzy search" },
        {
            "<leader>ff",
            function()
                require("telescope.builtin").find_files({
                    hidden = true,
                    find_command = { "fd", "-t", "f" },
                    follow = true,
                })
            end,
            desc = "Search files",
        },
        { "<leader>fe", ":Telescope live_grep<CR>",      desc = "Exact search" },
        { "<leader>fb", ":Telescope buffers<CR>",        desc = "Search buffers" },
        { "<leader>fh", ":Telescope help_tags<CR>",      desc = "Search tags" },
        { "<leader>fk", ":Telescope keymaps<CR>",        desc = "Search keys" },
        { "<leader>fd", ":Telescope diagnostics<CR>",    desc = "Search diagnostics" },
        { "<leader>fc", ":Telescope aerial<CR>",         desc = "Search code parts" },
        {
            "<leader>gc",
            ":Telescope git_bcommits<CR>",
            desc = "Show commit history for this buffer",
        },
        {
            "<leader>gb",
            ":Telescope git_branches<CR>",
            desc = "Show all available branches",
        },
    },
    config = function()
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("ui-select")
        require("telescope").load_extension("aerial")
        local builtin = require("telescope.builtin")
        function FuzzyFindFiles()
            builtin.grep_string({
                path_display = { "smart" },
                only_sort_text = true,
                word_match = "-w",
                search = "",
                additional_args = { "--hidden", "--glob", "!.git/" },
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
