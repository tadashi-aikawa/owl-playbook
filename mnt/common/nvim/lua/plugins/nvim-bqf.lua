return {
  "kevinhwang91/nvim-bqf",
  dependencies = { "junegunn/fzf" },
  event = "FileType qf",
  opts = {
    func_map = {
      openc = "<CR>",
      open = "o",
      split = "<C-s>",
      vsplit = "<F12>",
      tabc = "<Space>t",
    },
  },
}
