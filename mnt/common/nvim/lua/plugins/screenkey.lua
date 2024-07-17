return {
  "NStefan002/screenkey.nvim",
  lazy = false,
  config = function()
    require("screenkey").setup({
      compress_after = 5,
      group_mappings = true,
      keys = {
        ["<ESC>"] = "Esc",
        ["<TAB>"] = "Tab",
      },
      win_opts = {
        width = 50,
        height = 1,
        border = "single",
        title = "Keys",
      },
      clear_after = 5,
    })
  end,
}
