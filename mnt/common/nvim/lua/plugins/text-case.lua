return {
  "johmsalas/text-case.nvim",
  keys = function()
    local opts = { noremap = true, silent = true }
    return {
      { "<Space>as", "<cmd>:lua require('textcase').current_word('to_snake_case')<CR>", opts },
      { "<Space>al", "<cmd>:lua require('textcase').current_word('to_snake_case')<CR>", opts },
      { "<Space>ac", "<cmd>:lua require('textcase').current_word('to_camel_case')<CR>", opts },
      { "<Space>ap", "<cmd>:lua require('textcase').current_word('to_pascal_case')<CR>", opts },
      { "<Space>ak", "<cmd>:lua require('textcase').current_word('to_dash_case')<CR>", opts },
      { "<Space>au", "<cmd>:lua require('textcase').current_word('to_constant_case')<CR>", opts },
    }
  end,
  cmd = {
    "Subs",
  },
}
