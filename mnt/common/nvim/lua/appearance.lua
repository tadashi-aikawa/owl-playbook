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
-- For illuminate.nvim
vim.api.nvim_set_hl(0, "IlluminatedWordText", { reverse = true }) -- markdown.nvimでも動作するように
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { fg = "white", bg = "#23ab23" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { fg = "white", bg = "#ef7878" })
-- Current line
vim.api.nvim_set_hl(0, "CursorLine", { bg = nil })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#888888", fg = "#efef33" })
-- Flash.nvim
vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#efef33", bold = true })
vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#3d59a1", bold = true })
-- nvim-treesitter-context
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "black" })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "black" })
vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true })
-- gitgraph.nvim
vim.api.nvim_set_hl(0, "GitGraphHash", { fg = "#777777" })
vim.api.nvim_set_hl(0, "GitGraphTimestamp", { fg = "#facbcb" })
vim.api.nvim_set_hl(0, "GitGraphAuthor", { fg = "#45cd78" })
vim.api.nvim_set_hl(0, "GitGraphBranchName", { bg = "#888888", fg = "#efef33" })
vim.api.nvim_set_hl(0, "GitGraphBranchTag", { bg = "#3d59a1" })
vim.api.nvim_set_hl(0, "GitGraphBranchMsg", { fg = "lightgray" })
-- render-markdown
vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#070707" })
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#454545" })
vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = "lightgray" })

-- snacks.picker
vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "LineNr" })

-- XXX: boldがなぜか見た目にFBされないので。。
vim.api.nvim_set_hl(0, "@markup.strong", { underdouble = true })
-- 水平dividerは目立たせない
vim.api.nvim_set_hl(0, "@punctuation.special.markdown", { fg = "lightgray" })

-- Yankした範囲をハイライトさせる
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 })
  end,
})

-- LSP
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = "#888888", fg = "#efef33" })
