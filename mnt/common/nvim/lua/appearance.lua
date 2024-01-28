local u = require("utils")

-- Color scheme
u.set.background = "dark"

-- 行番号の表示
u.set.number = true

-- ステータスバーは分割しない
u.set.laststatus = 3

-- coc-highlightの表示を早めるために4000msから短くする
u.set.updatetime = 200

-- Highlight
vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#885522" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#661111" })
-- vim.api.nvim_set_hl(0, "MatchParen", { fg = "#121212", bg = "#EE9999" })
-- -- For illuminate.nvim
-- vim.api.nvim_set_hl(0, "IlluminatedWordText", { fg = 'lightgray', bg = 'darkcyan' })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { fg = "black", bg = "#abab23" })
-- vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { fg = 'lightgray', bg = 'darkred' })

-- Yankした範囲をハイライトさせる
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 })
  end,
})
