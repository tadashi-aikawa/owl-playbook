return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  config = function()
    require("quicker").setup({})
  end,
}