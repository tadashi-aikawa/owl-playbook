return {
  "shortcuts/no-neck-pain.nvim",
  keys = {
    {
      "<M-n>",
      ":NoNeckPain<CR>",
      silent = true,
    },
  },
  cmd = "NoNeckPain",
  opts = {
    width = 140,
    autocmds = {
      enableOnVimEnter = true,
      enableOnTabEnter = true,
    },
    buffers = {
      colors = { background = "tokyonight-moon" },
    },
  },
}
