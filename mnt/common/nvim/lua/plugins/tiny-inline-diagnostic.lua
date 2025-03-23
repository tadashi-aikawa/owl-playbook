return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      options = {
        show_source = true,
        multilines = {
          enabled = true,
          always_show = true,
        },
      },
    })
    vim.diagnostic.config({
      -- native LSPのインライン表示を無効にする
      virtual_text = false,
    })
  end,
}
