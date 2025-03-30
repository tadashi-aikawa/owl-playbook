return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufNewFile", "BufRead" },
  opts = {
    sign_priority = 1,
  },
}
