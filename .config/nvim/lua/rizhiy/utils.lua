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
    for _, buf in ipairs(buffers) do
        vim.schedule(function() vim.bo[buf].modifiable = state end)
    end
end

--- @return table
function M.get_promise()
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
            vim.defer_fn(function() promise.done(obj) end, 10)
        end
    end

    return promise
end

return M
