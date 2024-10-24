local opts = { noremap = true, silent = true }

return {
  "johmsalas/text-case.nvim",
  keys = {
    { "gas", "<cmd>:lua require('textcase').current_word('to_snake_case')<CR>", opts },
    { "gal", "<cmd>:lua require('textcase').current_word('to_snake_case')<CR>", opts },
    { "gac", "<cmd>:lua require('textcase').current_word('to_camel_case')<CR>", opts },
    { "gap", "<cmd>:lua require('textcase').current_word('to_pascal_case')<CR>", opts },
    { "gak", "<cmd>:lua require('textcase').current_word('to_dash_case')<CR>", opts },
    { "gau", "<cmd>:lua require('textcase').current_word('to_constant_case')<CR>", opts },
  },
}
