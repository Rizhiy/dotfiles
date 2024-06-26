return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
        require("gitsigns").setup({
            current_line_blame = true,
            signs_staged_enable = true,
            current_line_blame_opts = {
                delay = 100,
            },
            on_attach = function(_)
                local gs = require("gitsigns")

                local map = require("rizhiy.keys").map
                local nmap = require("rizhiy.keys").nmap

                -- Navigation
                nmap("<leader>gp", gs.prev_hunk, { desc = "Next hunk" })
                nmap("<leader>gn", gs.next_hunk, { desc = "Prev hunk" })

                -- Actions
                nmap("<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
                nmap("<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
                map(
                    "<leader>gs",
                    function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                    { mode = "v", desc = "Toggle hunk staging" }
                )
                map(
                    "<leader>gr",
                    function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                    { mode = "v", desc = "Reset selected" }
                )
                nmap("<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
                nmap("<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                nmap("<leader>gR", gs.reset_buffer, { desc = "Rest buffer" })
                nmap("<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
                nmap("<leader>gd", gs.diffthis, { desc = "Diff this current" })
                nmap("<leader>gD", function() gs.diffthis("~") end, { desc = "Diff with prev commit" })
                nmap("<leader>gt", gs.toggle_deleted, { desc = "Toggle deleted" })

                -- Text object
                map("ih", ":<C-U>Gitsigns select_hunk<CR>", { mode = { "o", "x" } })
            end,
        })
        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment", default = true })
    end,
}
