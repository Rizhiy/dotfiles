return {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = false,
    tag = "v2.0.2",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        {
            "rcarriga/nvim-notify",
            opts = {
                background_colour = "#000000",
            },
        },
    },
    keys = {
        { "<leader>fm", ":Noice telescope<CR>", desc = "Search message", silent = true },
        { "<leader>ml", ":Noice last<CR>", desc = "Show last message", silent = true },
        { "<leader>me", ":Noice errors<CR>", desc = "Show errors in a split", silent = true },
        { "<leader>md", ":Noice dismiss<CR>", desc = "Hide all messages", silent = true },
    },
    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treestureitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        routes = {
            {
                filter = {
                    any = {
                        {
                            event = "msg_show",
                            kind = "",
                            find = "written",
                        },
                        {
                            event = "msg_show",
                            kind = "",
                            find = "fewer lines",
                        },
                        {
                            event = "msg_show",
                            kind = "",
                            find = "more lines",
                        },
                    },
                },
                opts = { skip = true },
            },
        },
    },
}
