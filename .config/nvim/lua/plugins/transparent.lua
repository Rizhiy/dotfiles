return {
    "xiyaowong/transparent.nvim",
    config = function ()
        require("transparent").setup(   {
            extra_groups = {
                "WinSeparator",
            },
            exclude_groups = {
                "Cursor",
                "CursorLine"
            }
        })
        vim.cmd(":TransparentEnable")
    end
}
