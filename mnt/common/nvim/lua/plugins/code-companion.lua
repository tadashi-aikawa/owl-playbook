return {
  "olimorris/codecompanion.nvim",
  keys = {
    {
      "<Space>cc",
      ":CodeCompanionChat<CR>",
      silent = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {}, require("envs.code-companion").opts)
  end,
}
