return {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    config = function(_)
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- lua
                null_ls.builtins.diagnostics.selene,
                null_ls.builtins.formatting.stylua,
                -- python
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                -- yaml
                null_ls.builtins.diagnostics.yamllint,
                null_ls.builtins.diagnostics.actionlint, -- github actions
                null_ls.builtins.formatting.yamlfix,
                -- markdown
                null_ls.builtins.diagnostics.markdownlint,
                -- jinja
                null_ls.builtins.diagnostics.djlint,
                null_ls.builtins.formatting.djlint,
                -- general
                null_ls.builtins.diagnostics.codespell.with({
                    extra_args = { "--ignore-words", vim.fn.stdpath("data") .. "/spell/words.add" },
                }),
                null_ls.builtins.formatting.prettier.with({
                    disabled_filetypes = { "lua", "python", "yaml", "htmldjango" },
                }),
            },
        })
        local nmap = require("rizhiy.keys").nmap

        nmap("<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })

        local autocmd = vim.api.nvim_create_autocmd
        autocmd({ "BufWritePre" }, {
            callback = function()
                local client = vim.lsp.get_clients({ bufnr = 0 })[1]
                if client and client.supports_method("textDocument/formatting") then vim.lsp.buf.format() end
            end,
        })
    end,
}
