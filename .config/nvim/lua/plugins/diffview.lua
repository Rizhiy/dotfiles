return {
    "sindrets/diffview.nvim",
    keys = {
        {
            "<leader>gv",
            function()
                local lib = require("diffview.lib")
                local view = lib.get_current_view()
                if view then
                    -- Current tabpage is a Diffview; close it
                    vim.cmd.DiffviewClose()
                else
                    -- No open Diffview exists: open a new one
                    vim.cmd.DiffviewOpen()
                end
            end,
            desc = "Toggle DiffView",
        },
    },
    opts = {
        hooks = {
            diff_buf_read = function()
                -- make "diff" buffers non-modifiable
                local fname = vim.fn.expand('%:h')
                if fname:match("diffview") then
                    vim.opt_local.modifiable = false
                end
            end
        }
    }
}
