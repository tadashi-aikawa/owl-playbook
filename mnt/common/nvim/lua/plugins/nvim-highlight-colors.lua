return {
  "brenoprata10/nvim-highlight-colors",
  config = function()
    require("nvim-highlight-colors").setup({
      render = "virtual",
      virtual_symbol = "",
      virtual_symbol_position = "eol",
      virtual_symbol_suffix = "",
      enable_tailwind = true,
    })
  end,
}
