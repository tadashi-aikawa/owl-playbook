-----------------------------------------------------
-- キーバインド
-----------------------------------------------------
-- プラグインのキーバインドはプラグインの方で行う

local u = require("utils")

-- Hippie completion
if u.is_windows then
  vim.keymap.set("i", "<S-F6>", "<C-x><C-p>")
else
  vim.keymap.set("i", "<F18>", "<C-x><C-p>") -- Ubuntu(WSL)ではS-F6がF18となるため
end
-- cnext / cprevious
vim.keymap.set("n", "<Space>J", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "<Space>K", ":cprevious<CR>", { silent = true })
-- バッファ切り替え
vim.keymap.set("n", "<Space>r", ":b#<CR>", { silent = true })
vim.keymap.set("n", "<Space>e", ":BufferPick<CR>", { silent = true })
vim.keymap.set("n", "<Space>l", ":BufferNext<CR>", { silent = true })
vim.keymap.set("n", "<Space>h", ":BufferPrevious<CR>", { silent = true })
vim.keymap.set("n", "<Space>q", ":Bdelete<CR>", { silent = true })
vim.keymap.set("n", "<Space>c", ":BufferCloseAllButVisible<CR>", { silent = true })
-- windows split
vim.keymap.set("n", "<C-w><F12>", ":vsplit<CR>", { silent = true })
-- tab split
vim.keymap.set("n", "<C-w>t", ":tab split<CR>", { silent = true })
-- 行補完
vim.keymap.set("i", "<C-l>", "<C-x><C-l>", { silent = true })
-- markdown装飾
vim.keymap.set("n", "<Space>b", function()
  vim.cmd("normal ysiW*.")
end, { silent = true })
vim.keymap.set("n", "<Space>@", function()
  vim.cmd("normal ysiW`")
end, { silent = true })
vim.keymap.set("n", "<Space>-", ":s/*/\\~/g<CR>", { silent = true })
-- カレントウィンドウのファイル相対パスをコピー
vim.keymap.set("n", "<Space>y", function()
  local relative_path = vim.fn.expand("%:~:.")
  vim.fn.setreg("+", relative_path)
  vim.notify("Copy: " .. relative_path)
end, { silent = true })
