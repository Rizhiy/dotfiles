return {
    'nvim-telescope/telescope.nvim',
    lazy = false,
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    keys = {
        {"<leader>f",  "<cmd>lua fuzzyFindFiles{}<CR>", desc="Fuzzy search"},
        {'<leader>ff', ":Telescope find_files<CR>", desc="Search files"},
        {'<leader>fe', ":Telescope live_grep<CR>", desc="Exact search"},
        {'<leader>fb', ":Telescope buffers<CR>", desc="Search buffers"},
        {'<leader>fh', ":Telescope help_tags<CR>", desc="Search tags"},
        {'<leader>fk', ":Telescope keymaps<CR>", desc="Search keys"},
    },
    config = function ()
        require('telescope').load_extension('fzf')
        local builtin = require('telescope.builtin')
        function fuzzyFindFiles()
            builtin.grep_string({
                path_display = { 'smart' },
                only_sort_text = true,
                word_match = "-w",
                search = '',
            })
        end
    end
}
