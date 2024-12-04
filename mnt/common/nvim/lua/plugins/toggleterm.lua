return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {},
  keys = {
    { "<Space>i", ":ToggleTerm direction=float<CR>", silent = true },
    { "<Space>,", ":ToggleTerm size=20<CR>", silent = true },
    { "<Space>.", ":ToggleTerm size=35<CR>", silent = true },
    {
      "<Space>t",
      function()
        local curdir = vim.bo.filetype == "oil" and require("oil").get_current_dir() or vim.fn.expand("%:p:h")
        vim.cmd("ToggleTerm dir=" .. curdir)
      end,
      silent = true,
    },
    { "<ESC>", [[<C-\><C-n>]], mode = "t", silent = true },
  },
}
