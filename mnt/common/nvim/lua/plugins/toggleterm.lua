return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({})
    vim.keymap.set("n", "<Space>i", ":ToggleTerm direction=float<CR>", { silent = true })
    vim.keymap.set("n", "<Space>,", ":ToggleTerm size=20<CR>", { silent = true })
    vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], { silent = true })
  end,
}
