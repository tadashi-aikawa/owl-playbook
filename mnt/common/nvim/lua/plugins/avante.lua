return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  -- 使うときだけ有効にする
  enabled = false,
  --
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    provider = "openai",
    auto_suggestions_provider = "openai",
  },
}
