return {
    "danymat/neogen",
    keys = {
        { "<leader>cd", function() require("neogen").generate() end, desc = "Create Docstring" },
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
