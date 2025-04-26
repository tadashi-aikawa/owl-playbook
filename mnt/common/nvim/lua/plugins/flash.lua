return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    label = {
      distance = false,
    },
    modes = {
      search = {
        enabled = false,
      },
      char = {
        enabled = false,
      },
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "R",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#efef33", bold = true })
        vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#3d59a1", bold = true })
      end,
    })
  end,
}
