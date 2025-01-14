return {
  "yetone/avante.nvim",
  keys = {
    {
      "<Space>aa",
      function()
        require("avante").ask()
      end,
    },
    {
      "<Space>ae",
      function()
        require("avante").edit()
      end,
    },
  },
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      hints = { enabled = false },
      mappings = {
        ask = "<Space>aa",
        edit = "<Space>ae",
        --- @class AvanteConflictMappings
        submit = {
          normal = "<CR>",
          insert = "<F12>", -- Ctrl+Enter
        },
      },
      windows = {
        width = 40,
      },
    }, require("envs.avante").opts)
  end,
}
