return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    {
      "<Space>s",
      function()
        require("treesj").split()
      end,
      silent = true,
    },
    {
      "<Space><S-j>",
      function()
        require("treesj").join()
      end,
      silent = true,
    },
  },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
  end,
}
