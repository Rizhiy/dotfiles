return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
    keys = {
        {
            -- See `:help K` for why this keymap
            "K",
            function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then vim.lsp.buf.hover() end
            end,
            desc = "Show Fold/Documentation",
        },
    },
    lazy = false,
    config = function()
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (" 󰁂 %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "MoreMsg" })
            return newVirtText
        end

        local handler = function(
            virtual_text_chunks, -- The start_line's text.
            start_line,          -- Start lines of fold.
            end_line,            -- End lines of fold.
            text_width,          -- Total text width.
            truncate,            -- fun(str: string, width: number): string Truncation function.
            ctx                  -- Context for the fold.
        )
            -- new_virtual_text_chunks = virtual_text_chunks
            local line_delta = (" 󰁂 %d "):format(end_line - start_line)
            local remaining_width = text_width - vim.fn.strdisplaywidth(ctx.text) - vim.fn.strdisplaywidth(line_delta)
            table.insert(virtual_text_chunks, { line_delta, "MoreMsg" })
            local line = start_line
            while remaining_width > 0 and line < end_line do
                local line_text = vim.api.nvim_buf_get_lines(ctx.bufnr, line, line + 1, true)[1]
                line_text = " " .. vim.trim(line_text)
                if line < end_line - 1 then line_text = line_text .. "" end
                local line_text_width = vim.fn.strdisplaywidth(line_text)
                if line_text_width <= remaining_width - 2 then
                    remaining_width = remaining_width - line_text_width
                else
                    line_text = truncate(line_text, remaining_width - 2) .. "…"
                    remaining_width = remaining_width - vim.fn.strdisplaywidth(line_text)
                end
                table.insert(virtual_text_chunks, { line_text, "Comment" })
                line = line + 1
            end
            return virtual_text_chunks
        end

        require("ufo").setup({
            provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end,
            open_fold_hl_timeout = 250,
            fold_virt_text_handler = handler,
            preview = {
                win_config = {
                    border = require("rizhiy.border").Border(),
                    winhighlight = "Normal:Folded",
                    winblend = 0,
                },
                mappings = {
                    scrollU = "<C-k>",
                    scrollD = "<C-j>",
                },
            },
        })

        -- start folded
        local function applyFoldsAndThenCloseAllFolds(bufnr, providerName)
            require("async")(function()
                bufnr = bufnr or vim.api.nvim_get_current_buf()
                local ufo = require("ufo")
                ufo.attach(bufnr)

                local ranges = ufo.getFolds(bufnr, providerName)
                if vim.tbl_isempty(ranges) then return end

                local ok = ufo.applyFolds(bufnr, ranges)
                if not ok then return end

                ufo.closeFoldsWith(1)
            end)
        end

        vim.api.nvim_create_autocmd("BufRead", {
            pattern = "*",
            callback = function(e) applyFoldsAndThenCloseAllFolds(e.buf, "treesitter") end,
        })
    end,
}
