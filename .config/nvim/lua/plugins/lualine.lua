return {
    'nvim-lualine/lualine.nvim',
    dependencies= { 'nvim-tree/nvim-web-devicons', opt = true },
    config = {
        sections = {
            lualine_c = {
                {
                    'filename',
                    path = 1,
                }
            }
        }
    }
}
