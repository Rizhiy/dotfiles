return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = true,
    config = function()
        require("nvim-treesitter-textobjects").setup({
            select = { lookahead = true },
            move = { set_jumps = true },
        })

        local map = require("rizhiy.keys").map
        local select = require("nvim-treesitter-textobjects.select")
        local swap = require("nvim-treesitter-textobjects.swap")
        local move = require("nvim-treesitter-textobjects.move")

        local selections = {
            ["a="] = { "@assignment.outer", "Select outer part of an assignment" },
            ["i="] = { "@assignment.inner", "Select inner part of an assignment" },
            ["l="] = { "@assignment.lhs", "Select left hand side of an assignment" },
            ["r="] = { "@assignment.rhs", "Select right hand side of an assignment" },
            ["aa"] = { "@parameter.outer", "Select outer part of a parameter/argument" },
            ["ia"] = { "@parameter.inner", "Select inner part of a parameter/argument" },
            ["ai"] = { "@conditional.outer", "Select outer part of a conditional" },
            ["ii"] = { "@conditional.inner", "Select inner part of a conditional" },
            ["al"] = { "@loop.outer", "Select outer part of a loop" },
            ["il"] = { "@loop.inner", "Select inner part of a loop" },
            ["af"] = { "@call.outer", "Select outer part of a function call" },
            ["if"] = { "@call.inner", "Select inner part of a function call" },
            ["am"] = { "@function.outer", "Select outer part of a method/function definition" },
            ["im"] = { "@function.inner", "Select inner part of a method/function definition" },
            ["ac"] = { "@class.outer", "Select outer part of a class" },
            ["ic"] = { "@class.inner", "Select inner part of a class" },
        }
        for key, selection in pairs(selections) do
            map(key, function() select.select_textobject(selection[1], "textobjects") end, {
                mode = { "x", "o" },
                desc = selection[2],
            })
        end

        map("<leader>na", function() swap.swap_next("@parameter.inner") end, { desc = "Swap argument with next" })
        map("<leader>nm", function() swap.swap_next("@function.outer") end, { desc = "Swap function with next" })
        map(
            "<leader>pa",
            function() swap.swap_previous("@parameter.inner") end,
            { desc = "Swap argument with previous" }
        )
        map(
            "<leader>pm",
            function() swap.swap_previous("@function.outer") end,
            { desc = "Swap function with previous" }
        )

        local movements = {
            ["]="] = { move.goto_next_start, "@assignment.outer", "Next assignment" },
            ["]a"] = { move.goto_next_start, "@parameter.outer", "Next parameter/argument" },
            ["]i"] = { move.goto_next_start, "@conditional.outer", "Next conditional" },
            ["]l"] = { move.goto_next_start, "@loop.outer", "Next loop" },
            ["]f"] = { move.goto_next_start, "@call.outer", "Next function call" },
            ["]m"] = { move.goto_next_start, "@function.outer", "Next method/function def" },
            ["]c"] = { move.goto_next_start, "@class.outer", "Next class" },
            ["[="] = { move.goto_previous_start, "@assignment.outer", "Previous assignment" },
            ["[a"] = { move.goto_previous_start, "@parameter.outer", "Previous parameter/argument" },
            ["[i"] = { move.goto_previous_start, "@conditional.outer", "Previous conditional" },
            ["[l"] = { move.goto_previous_start, "@loop.outer", "Previous loop" },
            ["[f"] = { move.goto_previous_start, "@call.outer", "Previous function call" },
            ["[m"] = { move.goto_previous_start, "@function.outer", "Previous method/function def" },
            ["[c"] = { move.goto_previous_start, "@class.outer", "Previous class" },
        }
        for key, movement in pairs(movements) do
            map(key, function() movement[1](movement[2], "textobjects") end, {
                mode = { "n", "x", "o" },
                desc = movement[3],
            })
        end

        local repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
        map(";", repeat_move.repeat_last_move, { mode = { "n", "x", "o" } })
        map(",", repeat_move.repeat_last_move_opposite, { mode = { "n", "x", "o" } })
        map("f", repeat_move.builtin_f_expr, { mode = { "n", "x", "o" }, expr = true })
        map("F", repeat_move.builtin_F_expr, { mode = { "n", "x", "o" }, expr = true })
        map("t", repeat_move.builtin_t_expr, { mode = { "n", "x", "o" }, expr = true })
        map("T", repeat_move.builtin_T_expr, { mode = { "n", "x", "o" }, expr = true })
    end,
}
