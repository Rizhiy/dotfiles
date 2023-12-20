return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    { "s", function() require("flash").jump() end, desc = "Flash" },
    { "S", function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
