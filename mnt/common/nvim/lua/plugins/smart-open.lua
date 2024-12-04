local u = require("utils")

return {
  "danielfalk/smart-open.nvim",
  dependencies = {
    { "kkharji/sqlite.lua" },
    { "nvim-telescope/telescope-fzy-native.nvim" },
  },
  config = function()
    if u.is_windows then
      local home = os.getenv("USERPROFILE")
      vim.g.sqlite_clib_path = home .. "/lib/sqlite3.dll"
    end
  end,
  lazy = true,
}
