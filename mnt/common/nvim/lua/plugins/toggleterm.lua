return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({})
    vim.keymap.set("n", "<Space>i", ":ToggleTerm direction=float<CR>", { silent = true })
    vim.keymap.set("n", "<Space>,", ":ToggleTerm size=20<CR>", { silent = true })
    vim.keymap.set("n", "<Space>t", function()
      local curdir = vim.bo.filetype == "oil" and require("oil").get_current_dir() or vim.fn.expand("%:p:h")
      vim.cmd("ToggleTerm dir=" .. curdir)
    end, { silent = true })
    vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], { silent = true })
  end,
}
