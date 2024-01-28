return {
  "nvimdev/lspsaga.nvim",
  config = function()
    require("lspsaga").setup({
      code_action = {
        extend_gitsigns = true,
        keys = {
          quit = "<ESC>",
        },
      },
      lightbulb = {
        enable = false,
      },
      finder = {
        max_height = 0.7,
        left_width = 0.3,
        right_width = 0.6,
        keys = {
          shuttle = "<Space>w",
          toggle_or_open = "<CR>",
        },
      },
      diagnostic = {
        keys = {
          quit = "<ESC>",
        },
      },
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
