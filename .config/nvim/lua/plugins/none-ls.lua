return {
    "nvimtools/none-ls.nvim",
    -- enabled = false,
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
                -- general
                null_ls.builtins.diagnostics.codespell.with({
                    extra_args = { "--ignore-words", vim.fn.stdpath("data") .. "/spell/words.add" },
                }),
                null_ls.builtins.formatting.prettier,
            },
        })
        local nmap = require("rizhiy.keys").nmap

        nmap("<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })

        local autocmd = vim.api.nvim_create_autocmd
        autocmd({ "BufWritePre" }, {
            callback = function(_) vim.lsp.buf.format() end,
        })
    end,
}
