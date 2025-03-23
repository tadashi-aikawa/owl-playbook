return {
  "j-hui/fidget.nvim",
  event = { "LspAttach" },
  opts = {},
  config = function()
    require("codecompanion.fidget-spinner"):init()
  end,
}
