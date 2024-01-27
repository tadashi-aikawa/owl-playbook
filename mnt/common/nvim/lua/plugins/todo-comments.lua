return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { 'BufNewFile', 'BufRead' },
  keys = {
    { '<C-j>x', ':TodoTelescope<cr>', silent = true },
  },
  opts = {
    sign_priority = 1
  },
}
