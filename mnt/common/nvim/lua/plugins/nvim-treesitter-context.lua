return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufNewFile", "BufRead" },
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "black" })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "black" })
        vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true })
      end,
    })
  end,
}
