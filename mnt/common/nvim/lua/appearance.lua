vim.cmd("colorscheme tokyonight")

-- 行番号の表示
vim.opt.number = true

-- カーソル行強化
vim.opt.cursorline = true

-- ステータスバーは分割しない
vim.opt.laststatus = 3

-- suggestionsの上限
vim.opt.pumheight = 10

-- Line
vim.api.nvim_set_hl(0, "LineNr", { fg = "#888888" })
-- Comment
vim.api.nvim_set_hl(0, "Comment", { fg = "#888888" })
-- Highlight
vim.api.nvim_set_hl(0, "YankHighlight", { reverse = true })
vim.api.nvim_set_hl(0, "Visual", { bg = "#565612" })
-- Current line
vim.api.nvim_set_hl(0, "CursorLine", { bg = nil })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#888888", fg = "#efef33" })

-- LSP
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = "#888888", fg = "#efef33" })

-- Markdown
-- XXX: boldがなぜか見た目にFBされないので。。
vim.api.nvim_set_hl(0, "@markup.strong", { underdouble = true })
-- 水平dividerは目立たせない
vim.api.nvim_set_hl(0, "@punctuation.special.markdown", { fg = "lightgray" })
-- ヘッダ (render-markdownにあわせる)
vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#efef33", bg = "#3d59a1" })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#FF9966", bg = "#665050" })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#FFC777", bg = "#58535f" })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#FFC777", bg = "#493e4a" })
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#FFC777", bg = nil })
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#FFC777", bg = nil })

-- Yankした範囲をハイライトさせる
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 })
  end,
})
