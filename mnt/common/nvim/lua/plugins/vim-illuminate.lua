return {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      delay = 300,
      modes_denylist = { "i" },
      filetypes_denylist = {
        "aerial",
        "NvimTree",
        "notify",
        "markdown",
      },
    })
  end,
}
