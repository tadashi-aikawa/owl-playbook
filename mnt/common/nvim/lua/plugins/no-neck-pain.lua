return {
  "shortcuts/no-neck-pain.nvim",
  config = function()
    require("no-neck-pain").setup({
      width = 100,
      autocmds = {
        enableOnVimEnter = true,
      },
      buffers = {
        colors = { background = "tokyonight-moon" },
      },
    })
  end,
}
