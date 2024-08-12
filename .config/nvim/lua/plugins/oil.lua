local function get_git_ignored_files_in(dir)
    local found = vim.fs.find(".git", { upward = true, path = dir })
    if #found == 0 then return {} end

    local cmd =
        string.format('git -C %s ls-files --ignored --exclude-standard --others --directory | grep -v "/.*\\/"', dir)

    local handle = io.popen(cmd)
    if handle == nil then return end

    local ignored_files = {}
    for line in handle:lines("*l") do
        line = line:gsub("/$", "")
        table.insert(ignored_files, line)
    end
    handle:close()

    return ignored_files
end

return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "-", ":Oil<CR>", desc = "Open parent directory", silent = true },
    },
    opts = {
        keymaps = {
            ["?"] = "actions.show_help",

            ["<CR>"] = "actions.select",

            ["v"] = "actions.select_vsplit",
            ["-"] = "actions.select_split",

            ["<C-t>"] = "actions.select_tab",
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-r>"] = "actions.refresh",

            ["<BS>"] = "actions.parent",
            ["_"] = "actions.open_cwd",

            ["gs"] = "actions.change_sort",
            ["gx"] = "actions.open_external",
            ["g."] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = false,
        columns = {
            "mtime",
            "size",
            "icon",
        },
        skip_confirm_for_simple_edits = true,
        watch_for_changes = true,
        view_options = {
            is_hidden_file = function(name, _)
                local ignored_files = get_git_ignored_files_in(require("oil").get_current_dir())
                return vim.tbl_contains(ignored_files, name) or vim.startswith(name, ".")
            end,
        },
    },
}
