return {
  'stevearc/aerial.nvim',
  opts = {},
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  keys = {
    { '<C-j>o', ':AerialOpen<CR>', silent = true },
  },
  config = function()
    require("aerial").setup({
      layout = {
        default_direction = "float",
        min_width = 50
      },
      keymaps = {
        ["<ESC>"] = "actions.close",
      },
    })
  end
}
