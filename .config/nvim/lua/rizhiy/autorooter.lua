-- Array of file names indicating root directory.
local root_names = {
    ".git",
    "Makefile",
}

-- Table of directory names indicating parent of root directory
local List = require("plenary.collections.py_list")
local parent_names = List({
    "projects",
    ".config",
})

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

local set_root = function()
    if vim.g.SessionLoad == 1 then return end
    if vim.bo.filetype == "oil" then return end
    -- Get directory path to start search from
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then return end
    path = vim.fs.dirname(path)

    -- Try cache and resort to searching upward for root directory
    local root = root_cache[path]
    if root == nil then
        local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
        if root_file ~= nil then root = vim.fs.dirname(root_file) end
    end

    -- Try to find work_dir based on parent dir
    if root == nil then
        local prev_dir = path
        for dir in vim.fs.parents(path) do
            if parent_names:contains(vim.fs.basename(dir)) then
                root = prev_dir
                break
            end
            prev_dir = dir
        end
    end

    -- TODO: Handle this better, probably don't run this if entering terminal
    if root == nil or root:find("^term") then return end
    -- Set current directory
    if root ~= nil then
        root_cache[path] = root
        vim.fn.chdir(root)
    end
end

vim.api.nvim_create_autocmd({ "BufEnter", "SessionLoadPost" }, {
    group = vim.api.nvim_create_augroup("MyAutoRoot", {}),
    callback = set_root,
})
