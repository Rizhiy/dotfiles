return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    config = function()
        require("nvim-treesitter.configs").setup({
            textobjects = {
                select = {
                    enable = true,
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                        ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                        ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                        ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

                        ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                        ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

                        ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                        ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

                        ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                        ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                        ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                        ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

                        ["am"] = {
                            query = "@function.outer",
                            desc = "Select outer part of a method/function definition",
                        },
                        ["im"] = {
                            query = "@function.inner",
                            desc = "Select inner part of a method/function definition",
                        },

                        ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
                        ["<leader>nm"] = "@function.outer", -- swap function with next
                    },
                    swap_previous = {
                        ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
                        ["<leader>pm"] = "@function.outer", -- swap function with previous
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]="] = { query = "@assignment.outer", desc = "Next assignment" },
                        ["]a"] = { query = "@parameter.outer", desc = "Next parameter/argument" },
                        ["]i"] = { query = "@conditional.outer", desc = "Next conditional" },
                        ["]l"] = { query = "@loop.outer", desc = "Next loop" },
                        ["]f"] = { query = "@call.outer", desc = "Next function call" },
                        ["]m"] = { query = "@function.outer", desc = "Next method/function def" },
                        ["]c"] = { query = "@class.outer", desc = "Next class" },
                    },
                    goto_previous_start = {
                        ["[="] = { query = "@assignment.outer", desc = "Previous assignment" },
                        ["[a"] = { query = "@parameter.outer", desc = "Previous parameter/argument" },
                        ["[i"] = { query = "@conditional.outer", desc = "Previous conditional" },
                        ["[l"] = { query = "@loop.outer", desc = "Previous loop" },
                        ["[f"] = { query = "@call.outer", desc = "Previous function call" },
                        ["[m"] = { query = "@function.outer", desc = "Previous method/function def" },
                        ["[c"] = { query = "@class.outer", desc = "Previous class" },
                    },
                },
            },
        })

        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

        local map = require("rizhiy.keys").map
        -- vim way: ; goes to the direction you were moving.
        map(";", ts_repeat_move.repeat_last_move, { mode = { "n", "x", "o" } })
        map(",", ts_repeat_move.repeat_last_move_opposite, { mode = { "n", "x", "o" } })

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        map("f", ts_repeat_move.builtin_f, { mode = { "n", "x", "o" } })
        map("F", ts_repeat_move.builtin_F, { mode = { "n", "x", "o" } })
        map("t", ts_repeat_move.builtin_t, { mode = { "n", "x", "o" } })
        map("T", ts_repeat_move.builtin_T, { mode = { "n", "x", "o" } })
    end,
}
