return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  event = "VeryLazy", -- hlslensでなぜか呼ばれるのでタイミングをあわせる
  config = function()
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require("ufo").setup()
  end,
}
