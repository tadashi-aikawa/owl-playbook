return {
  "MagicDuck/grug-far.nvim",
  keys = {
    { "gru", ":GrugFar<CR>", mode = { "n", "v" }, silent = true },
  },
  opts = {
    keymaps = {
      close = { n = "<localleader>q" },
      refresh = { n = "<localleader>r" },
      previewLocation = { n = "<localleader>d" },
      abort = { n = "<localleader>u" },
      historyOpen = { n = "<localleader>e" },
      historyAdd = { n = "<localleader>a" },
      swapEngine = { n = "<localleader>_" },
    },
  },
}
