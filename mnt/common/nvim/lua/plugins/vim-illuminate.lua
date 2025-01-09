return {
  "RRethy/vim-illuminate",
  event = "VeryLazy", -- BufReadが最適だがバランス的にVeryLazyの方がいい
  config = function()
    require("illuminate").configure({
      delay = 300,
      modes_denylist = { "i" },
      under_cursor = false,
      filetypes_denylist = {
        "aerial",
        "NvimTree",
        "notify",
        "markdown",
      },
    })
  end,
}
