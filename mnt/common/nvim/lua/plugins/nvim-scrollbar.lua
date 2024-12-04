return {
  "petertriho/nvim-scrollbar",
  event = "VeryLazy", -- nvim-hlslensの初期化にあわせる
  opts = {
    handle = {
      color = "gray",
    },
    marks = {
      Search = { color = "lime" },
      Error = { color = "red" },
      Warn = { color = "orange" },
      Info = { color = "cyan" },
      Hint = { color = "gray" },
      Misc = { color = "purple" },
    },
  },
}
