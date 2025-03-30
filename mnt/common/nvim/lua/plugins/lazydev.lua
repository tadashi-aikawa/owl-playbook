return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "snacks.nvim/lua/snacks" },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
}
