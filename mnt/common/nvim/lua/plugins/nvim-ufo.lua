return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    "kevinhwang91/nvim-ufo",
  },
  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require("ufo").setup()
  end,
}
