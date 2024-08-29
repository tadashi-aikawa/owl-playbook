return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
    vim.keymap.set("n", "<Space>s", require("treesj").split)
    vim.keymap.set("n", "<Space><S-j>", require("treesj").join)
  end,
}
