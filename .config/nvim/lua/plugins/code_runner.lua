return {
    "CRAG666/code_runner.nvim",
    keys = {
        {
            "<leader>rf",
            function() require("code_runner.commands").run_code(vim.bo.filetype) end,
            desc = "Run file",
        },
        {
            "<leader>ra",
            function() require("code_runner.commands").run_code(vim.bo.filetype, "args") end,
            desc = "Run file",
        },
    },

    opts = {
        focus = false,
        filetype = {
            ---@param mode string
            python = function(mode)
                local run_mode = require("code_runner.commands").run_mode
                local filepath = vim.api.nvim_buf_get_name(0)
                if mode == "args" then
                    run_mode(
                        string.format("python %s %s", filepath, vim.fn.input("Specify arguments: ")),
                        "python",
                        "term"
                    )
                else
                    run_mode("python " .. filepath, "python", "term")
                end
            end,
        },
    },
}
