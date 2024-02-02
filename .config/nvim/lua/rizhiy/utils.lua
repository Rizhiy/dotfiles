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
end

return M
