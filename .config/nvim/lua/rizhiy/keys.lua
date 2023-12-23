local M = {}

function M.map(keys, func, opts)
    opts = opts or {}
    opts.desc = opts.desc or ""
    local mode = opts.mode or ""
    opts.mode = nil
    if opts.silent == nil then opts.silent = true end

    vim.keymap.set(mode, keys, func, opts)
end

function M.nmap(keys, func, opts)
    opts = opts or {}
    opts.mode = "n"
    M.map(keys, func, opts)
end

return M
