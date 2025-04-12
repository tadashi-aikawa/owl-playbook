return {
  "lewis6991/gitsigns.nvim",
  event = { "BufNewFile", "BufRead" },
  keys = {
    { "<Space>d", ":Gitsigns preview_hunk<CR>", silent = true },
    {
      "<Space>D",
      function()
        require("gitsigns").diffthis()
      end,
      silent = true,
    },
    { "<Space>u", ":Gitsigns reset_hunk<CR>", silent = true },
    { "<Space>j", ":Gitsigns next_hunk<CR>", silent = true },
    { "<Space>k", ":Gitsigns prev_hunk<CR>", silent = true },
  },
  opts = {},
}
