return {
  "danielfalk/smart-open.nvim",
  dependencies = {
    { "kkharji/sqlite.lua" },
    { "nvim-telescope/telescope-fzy-native.nvim" },
  },
  config = function()
    local home = os.getenv("USERPROFILE")
    vim.g.sqlite_clib_path = home .. "/lib/sqlite3.dll"
  end,
}
