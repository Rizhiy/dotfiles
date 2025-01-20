return {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    config = function(_)
        local null_ls = require("null-ls")
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
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
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function() vim.lsp.buf.format({ async = false }) end,
                    })
                end
            end,
        })
        local nmap = require("rizhiy.keys").nmap

        nmap("<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })
    end,
}
