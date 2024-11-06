return {
  "monaqa/dial.nvim",
  keys = {
    {
      "<C-a>",
      mode = "n",
      function()
        require("dial.map").manipulate("increment", "normal")
      end,
    },
    {
      "<C-x>",
      mode = "n",
      function()
        require("dial.map").manipulate("decrement", "normal")
      end,
    },
    {
      "g<C-a>",
      mode = "n",
      function()
        require("dial.map").manipulate("increment", "gnormal")
      end,
    },
    {
      "g<C-x>",
      mode = "n",
      function()
        require("dial.map").manipulate("decrement", "gnormal")
      end,
    },
    {
      "<C-a>",
      mode = "v",
      function()
        require("dial.map").manipulate("increment", "visual")
      end,
    },
    {
      "<C-x>",
      mode = "v",
      function()
        require("dial.map").manipulate("decrement", "visual")
      end,
    },
    {
      "g<C-a>",
      mode = "v",
      function()
        require("dial.map").manipulate("increment", "gvisual")
      end,
    },
    {
      "g<C-x>",
      mode = "v",
      function()
        require("dial.map").manipulate("decrement", "gvisual")
      end,
    },
  },
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%Y-%m-%d"],
        augend.constant.alias.bool,
      },
    })
  end,
}
