return {
    "jghauser/follow-md-links.nvim",
    keys = { { "gd", function() require("follow-md-links").follow_link() end, desc = "Follow link", ft = "markdown" } },
    ft = { "markdown" },
}
