return {
  "kevinhwang91/nvim-bqf",
  config = function()
    require("bqf").setup({
      func_map = {
        split = "<C-s>",
        vsplit = "<F12>",
      },
    })
  end,
}
