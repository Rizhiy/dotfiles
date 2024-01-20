return {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-ui-select.nvim",
        { "stevearc/aerial.nvim", opts = {} },
        "nvim-telescope/telescope-github.nvim",
        "SalOrak/whaler",
        "nvim-telescope/telescope-file-browser.nvim",
        "piersolenski/telescope-import.nvim",
    },
    keys = {
        { "<leader>f", function() FuzzyFindFiles() end, desc = "Fuzzy search" },
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
        { "<leader>fe", ":Telescope live_grep<CR>", desc = "Exact search", silent = true },
        { "<leader>fb", ":Telescope buffers<CR>", desc = "Search buffers", silent = true },
        { "<leader>ft", ":Telescope help_tags<CR>", desc = "Search tags", silent = true },
        { "<leader>fk", ":Telescope keymaps<CR>", desc = "Search keys", silent = true },
        { "<leader>fd", ":Telescope diagnostics<CR>", desc = "Search diagnostics", silent = true },
        { "<leader>fc", ":Telescope aerial<CR>", desc = "Search code parts", silent = true },
        { "<leader>fp", ":Telescope whaler<CR>", desc = "Search projects", silent = true },
        { "<leader>fi", ":Telescope import<CR>", desc = "Search for import", silent = true },

        { "<leader>gc", ":Telescope git_bcommits<CR>", desc = "Show commit history (buffer)", silent = true },
        { "<leader>gb", ":Telescope git_branches<CR>", desc = "Show all available branches", silent = true },
        { "<leader>ghi", ":Telescope gh issues<CR>", desc = "Show GitHub issues", silent = true },
        { "<leader>ghp", ":Telescope gh pull_request<CR>", desc = "Show GitHub pull requests", silent = true },
        { "<leader>ghr", ":Telescope gh run<CR>", desc = "Show GitHub workflow runs", silent = true },
    },
    config = function()
        local telescope = require("telescope")
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        telescope.load_extension("aerial")
        telescope.load_extension("gh")
        telescope.load_extension("import")

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
        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
            extensions = {
                whaler = {
                    directories = { "~/projects" },
                    auto_cwd = false,
                    file_explorer = "telescope_file_browser",
                    theme = {
                        previwer = true,
                    },
                },
            },
        })
        telescope.load_extension("whaler")
    end,
}
