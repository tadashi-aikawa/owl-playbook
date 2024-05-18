return {
  "shortcuts/no-neck-pain.nvim",
  -- https://github.com/shortcuts/no-neck-pain.nvim/issues/352 がなおるまで固定
  tag = "v1.12.1",
  config = function()
    require("no-neck-pain").setup({
      width = 120,
      autocmds = {
        enableOnVimEnter = true,
      },
      buffers = {
        colors = { background = "tokyonight-moon" },
      },
    })

    vim.keymap.set("n", "<M-n>", ":NoNeckPain<CR>", { silent = true })
  end,
}
