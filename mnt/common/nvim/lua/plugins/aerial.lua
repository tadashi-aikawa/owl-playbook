return {
  "stevearc/aerial.nvim",
  ft = "markdown",
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
    { ft = "markdown", "<C-j>o", ":AerialOpen<CR>", silent = true },
  },
}
