return {
  dir = "~/git/github.com/tadashi-aikawa/ghostwriter.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<C-j>m", ":Ghostwrite<CR>", silent = true },
  },
  config = function()
    require("ghostwriter").setup({
      check = {
        { mark = "~", emoji = "loading" },
        { mark = "x", emoji = "ok_green" },
        { mark = "_", emoji = "rip" },
        { mark = "-", emoji = "togowl_pause" },
        { mark = " ", emoji = "circle-success" },
      },
      bullet = {
        emoji = "diamond_shape_with_a_dot_inside",
      },
    })
  end,
}
