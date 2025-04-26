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
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "IlluminatedWordText", { reverse = true }) -- markdown.nvimでも動作するように
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { fg = "white", bg = "#23ab23" })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { fg = "white", bg = "#ef7878" })
      end,
    })
  end,
}
