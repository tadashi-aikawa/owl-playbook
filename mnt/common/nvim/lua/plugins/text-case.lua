return {
  "johmsalas/text-case.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("textcase").setup({})
    require("telescope").load_extension("textcase")

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "gas", "<cmd>:lua require('textcase').current_word('to_snake_case')<CR>", opts)
    vim.keymap.set("n", "gal", "<cmd>:lua require('textcase').current_word('to_snake_case')<CR>", opts)
    vim.keymap.set("n", "gac", "<cmd>:lua require('textcase').current_word('to_camel_case')<CR>", opts)
    vim.keymap.set("n", "gap", "<cmd>:lua require('textcase').current_word('to_pascal_case')<CR>", opts)
    vim.keymap.set("n", "gak", "<cmd>:lua require('textcase').current_word('to_dash_case')<CR>", opts)
    vim.keymap.set("n", "gau", "<cmd>:lua require('textcase').current_word('to_constant_case')<CR>", opts)
  end,
  keys = {
    "ga",
    { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
  },
  lazy = false,
}
