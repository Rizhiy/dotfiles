local M = {}

function M.Border(hl_name)
    return {
        -- {"🭽", "FloatBorder"},
        -- {"▔", "FloatBorder"},
        -- {"🭾", "FloatBorder"},
        -- {"▕", "FloatBorder"},
        -- {"🭿", "FloatBorder"},
        -- {"▁", "FloatBorder"},
        -- {"🭼", "FloatBorder"},
        -- {"▏", "FloatBorder"},
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
    }
end

return M
