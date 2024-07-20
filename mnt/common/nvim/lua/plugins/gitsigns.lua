local u = require("utils")

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufNewFile", "BufRead" },
  keys = {
    { "<Space>d", ":Gitsigns preview_hunk<CR>", silent = true },
    { "<C-j>D", ":Gitsigns diffthis<CR>", silent = true },
    { "<Space>u", ":Gitsigns reset_hunk<CR>", silent = true },
    { "<Space>j", ":Gitsigns next_hunk<CR>", silent = true },
    { "<Space>k", ":Gitsigns prev_hunk<CR>", silent = true },
  },
  config = function()
    vim.defer_fn(function()
      require("gitsigns").setup({
        signcolumn = true,
        numhl = false,
      })
    end, u.is_windows and 200 or 0)
  end,
}
