return {
    "nvimtools/none-ls.nvim",
    -- enabled = false,
    config = function(_)
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- lua
                null_ls.builtins.diagnostics.luacheck.with({
                    extra_args = { "--globals", "vim" },
                }),
                null_ls.builtins.formatting.stylua,
                -- python
                null_ls.builtins.formatting.ruff,
                -- yaml
                null_ls.builtins.diagnostics.yamllint,
                null_ls.builtins.diagnostics.actionlint, -- github actions
                null_ls.builtins.formatting.yamlfix,
                -- toml
                null_ls.builtins.formatting.taplo,
                -- json
                null_ls.builtins.diagnostics.jsonlint,
                -- markdown
                null_ls.builtins.diagnostics.markdownlint,
                -- general
                null_ls.builtins.diagnostics.codespell.with({
                    extra_args = { "--ignore-words", vim.fn.stdpath("data") .. "/spell/words.add" },
                }),
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.trim_whitespace,
                null_ls.builtins.formatting.trim_newlines,
                null_ls.builtins.completion.spell,
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
