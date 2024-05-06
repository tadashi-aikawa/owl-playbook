return {
  "Wansmer/treesj",
  keys = { "<space>m" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
    vim.keymap.set("n", "<space>m", require("treesj").split)
  end,
}
