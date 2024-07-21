return {
  "windwp/nvim-ts-autotag",
  config = function()
    require("nvim-ts-autotag").setup({
      opts = {
        enable_close = false,
        enable_close_on_slash = true,
      },
    })
  end,
}
