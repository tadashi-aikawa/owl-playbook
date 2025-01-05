return {
  -- FIXME: If PR merged
  --"shortcuts/no-neck-pain.nvim",
  "tadashi-aikawa/no-neck-pain.nvim",
  keys = {
    {
      "<M-n>",
      ":NoNeckPain<CR>",
      silent = true,
    },
  },
  lazy = false,
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
