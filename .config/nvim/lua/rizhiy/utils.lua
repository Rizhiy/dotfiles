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
        vim.schedule(function()
            vim.print(buf)
            vim.bo[buf].modifiable = state
        end)
    end
end

return M
