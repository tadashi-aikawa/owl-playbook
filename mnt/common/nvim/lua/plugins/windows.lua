return {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
  },
  config = function()
    require("windows").setup({
      autowidth = {
        enable = false,
      },
    })

    vim.keymap.set("n", "<C-w>m", ":WindowsMaximize<CR>", { silent = true })
    vim.keymap.set("n", "<Space>v", ":WindowsMaximizeVertically<CR>", { silent = true })
    vim.keymap.set("n", "<Space>s", ":WindowsMaximizeHorizontally<CR>", { silent = true })
  end,
}
