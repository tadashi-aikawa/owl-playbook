return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "LspAttach" },
  opts = {
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
      right_width = 0.7,
      keys = {
        toggle_or_open = "<CR>",
        shuttle = "]w",
        vsplit = "<F12>", -- Ctrl+Enter
        split = "s",
      },
    },
    diagnostic = {
      keys = {
        quit = "<ESC>",
      },
    },
    definition = {
      width = 0.9,
      height = 0.8,
    },
    symbol_in_winbar = {
      enable = false,
    },
  },
}
