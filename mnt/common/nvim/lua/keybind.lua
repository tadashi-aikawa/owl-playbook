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
vim.keymap.set("n", "<Space>t", ":BufferRestore<CR>", { silent = true })
vim.keymap.set("n", "<Space>c", ":BufferCloseAllButVisible<CR>", { silent = true })
-- windows split
vim.keymap.set("n", "<C-w><F12>", ":vsplit<CR>", { silent = true })
