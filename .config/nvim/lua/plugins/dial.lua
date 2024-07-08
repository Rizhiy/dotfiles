return {
    "monaqa/dial.nvim",
    keys = {
        { "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end },
        { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end },
        { "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  mode = { "v" } },
        { "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  mode = { "v" } },
        { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = { "v" } },
        { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = { "v" } },
    },
}
