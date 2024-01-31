return {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      delay = 300,
      filetypes_denylist = {
        "aerial",
        "NvimTree",
        "notify",
      },
    })
  end,
}
