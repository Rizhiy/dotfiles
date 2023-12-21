return {
    "danymat/neogen",
    keys = {
        {"<leader>cd", ":lua require('neogen').generate()<CR>", desc="Create Docstring"}
    },
    config={
        languages = {
            python = {
                template = {
                    annotation_convention = "reST"
                }
            }
        }
    }
}
