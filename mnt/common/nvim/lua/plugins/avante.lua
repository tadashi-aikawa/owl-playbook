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
      "<Space>at",
      function()
        require("avante").toggle()
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
        focus = "<Space>af",
        toggle = {
          default = "<Space>at",
        },
        --- @class AvanteConflictMappings
        submit = {
          insert = "<F12>", -- Ctrl+Enter
        },
        sidebar = {
          switch_windows = "<Space>j",
          reverse_switch_windows = "<Space>k",
        },
      },
      windows = {
        width = 40,
        ask = {
          floating = true,
        },
      },
    }, require("envs.avante").opts)
  end,
}
