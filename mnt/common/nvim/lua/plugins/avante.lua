return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  -- 使うときだけ有効にする
  enabled = false,
  --
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
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
  },
}
