local u = require("utils")

-- Color scheme
u.set.background = "dark"

-- 行番号の表示
u.set.number = true

-- カーソル行強化
u.set.cursorline = true

-- ステータスバーは分割しない
u.set.laststatus = 3

-- Line
vim.api.nvim_set_hl(0, "LineNr", { fg = "#888888" })
-- Comment
vim.api.nvim_set_hl(0, "Comment", { fg = "#888888" })
-- Highlight
vim.api.nvim_set_hl(0, "YankHighlight", { reverse = true })
vim.api.nvim_set_hl(0, "Visual", { bg = "#565612" })
-- For illuminate.nvim
vim.api.nvim_set_hl(0, "IlluminatedWordText", { fg = "black", bg = "#abab23" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { fg = "black", bg = "#23ab23" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { fg = "#121212", bg = "#EE9999" })
-- Current line
vim.api.nvim_set_hl(0, "CursorLine", { bg = nil })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#888888", fg = "#efef33" })

-- Yankした範囲をハイライトさせる
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 })
  end,
})
