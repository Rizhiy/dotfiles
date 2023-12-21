return {
    "xiyaowong/transparent.nvim",
    config = function ()
        require("transparent").setup(   {
            extra_groups = {
                "WinSeparator",
                "Folded"
            },
            exclude_groups = {
                "CursorLine"
            }
        })
        vim.cmd(":TransparentEnable")
    end
}
