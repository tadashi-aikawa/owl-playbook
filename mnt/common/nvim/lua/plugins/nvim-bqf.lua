return {
  "kevinhwang91/nvim-bqf",
  dependencies = { "junegunn/fzf" },
  config = function()
    require("bqf").setup({
      func_map = {
        openc = "<CR>",
        open = "o",
        split = "<C-s>",
        vsplit = "<F12>",
      },
    })
  end,
}
