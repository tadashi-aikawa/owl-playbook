return {
  enabled = false,
  "stevearc/aerial.nvim",
  opts = {
    layout = {
      default_direction = "float",
      min_width = 50,
    },
    keymaps = {
      ["<ESC>"] = "actions.close",
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<C-j>o", ":AerialOpen<CR>", silent = true },
  },
}
