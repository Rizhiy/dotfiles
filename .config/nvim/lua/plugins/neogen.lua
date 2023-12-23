return {
    "danymat/neogen",
    keys = {
        { "<leader>cd", ":lua require('neogen').generate()<CR>", desc = "Create Docstring" },
    },
    opts = {
        languages = {
            python = {
                template = {
                    annotation_convention = "reST",
                },
            },
        },
    },
}
