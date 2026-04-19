return {
    "RRethy/vim-illuminate",
    enabled = false,
    event = "VeryLazy",
    config = function()
        require("illuminate").configure({
            should_enable = function(buf) return not require("rizhiy.utils").is_large_file(buf) end,
        })
    end,
}
