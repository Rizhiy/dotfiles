local M = {}

--- @param lines string[]
--- @return number
function M.get_indent(lines)
    local indent = 1 -- lua is one-indexed
    local indent_chars = { [" "] = true, ["\t"] = true }
    for char_idx = 1, #lines[1] do
        for _, line in ipairs(lines) do
            if #line > 0 then -- only check on non-empty lines
                local char = lines[1]:sub(char_idx, char_idx)
                if indent_chars[char] == nil then return indent end
            end
        end
        indent = indent + 1
    end
    return indent
end

--- @param buf number
function M.is_large_file(buf)
    local max_filesize = 50 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then return true end
    return false
end

--- @param buffers integer[]
--- @param state boolean
function M.change_modifiable(buffers, state)
    vim.schedule(function()
        local filtered_buffers = vim.tbl_filter(function(buf) return vim.fn.buflisted(buf) == 1 end, buffers)
        for _, buf in ipairs(filtered_buffers) do
            vim.bo[buf].modifiable = state
        end
    end)
end

--- @return table
function M.get_promise(poll_time)
    poll_time = poll_time or 25
    local promise = {
        updated = false,
        on_success = nil,
        on_failure = nil,
    }

    function promise.next(on_success, on_failure)
        promise.updated = true
        promise.on_success = on_success
        promise.on_failure = on_failure
    end

    function promise.done(obj)
        obj = obj or { code = 0 }
        if promise.updated then
            if obj.code == 0 then
                if promise.on_success then promise.on_success(obj) end
            else
                if promise.on_failure then promise.on_failure(obj) end
            end
        else
            vim.defer_fn(function() promise.done(obj) end, poll_time)
        end
    end

    return promise
end

function M.on_attach(_, bufnr)
    --  This function gets run when an LSP connects to a particular buffer.
    local nmap = function(keys, func, desc)
        if desc then desc = "LSP: " .. desc end
        -- NOTE: Do we need to pass buffer in here?
        require("rizhiy.keys").nmap(keys, func, { desc = desc, buffer = bufnr })
    end

    nmap("rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>d", function() vim.diagnostic.open_float({ scope = "cursor" }) end, "Show diagnostics under cursor")
    nmap("<leader>ds", ":Telescope diagnostics<CR>", "Show diagnostics")
    nmap("<leader>dt", ":TroubleToggle<CR>", "Show trouble")
    nmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
    nmap("[d", vim.diagnostic.goto_prev, "Previous diagnostic")

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
        -- Use VirtualText for transparency
        vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticVirtualText" .. type })
    end
end

return M
