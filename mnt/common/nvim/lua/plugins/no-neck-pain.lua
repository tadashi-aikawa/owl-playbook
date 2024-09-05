return {
  "shortcuts/no-neck-pain.nvim",
  config = function()
    require("no-neck-pain").setup({
      width = 140,
      autocmds = {
        enableOnVimEnter = true,
        enableOnTabEnter = true,
      },
      buffers = {
        colors = { background = "tokyonight-moon" },
      },
    })

    vim.keymap.set("n", "<M-n>", ":NoNeckPain<CR>", { silent = true })
  end,
}
