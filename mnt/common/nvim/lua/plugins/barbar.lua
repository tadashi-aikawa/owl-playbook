return {
  "romgrk/barbar.nvim",
  dependencies = { "nvim-web-devicons" },
  cmd = "BarbarEnable",
  event = { "BufNewFile", "BufRead" },
  opts = {
    animation = false,
    sidebar_filetypes = {
      ["no-neck-pain"] = {},
    },
  },
}
