return {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      delay = 300,
    })
  end,
}
