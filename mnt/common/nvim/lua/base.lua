local u = require("utils")

u.set.termguicolors = true

-----------------------------------------------------
-- 挙動
-----------------------------------------------------

-- 文字コード自動判別
u.set.encoding = "utf-8"
u.set.fileencodings = "utf-8,sjis"
-- 改行コード自動判別
u.set.fileformats = "unix,dos,mac"
-- swapfileを作成しない
vim.opt.swapfile = false
-- XXX: vue.jsでコメントアウトするためになぜか必要
vim.opt.updatetime = 100

-- バッファを未保存でも閉じる
u.set.hidden = true
-- バックスペースの有効化
u.set.backspace = "indent,eol,start"
-- コマンドのタイムラグをなくす
u.set.ttimeoutlen = 1
-- タブを基本2文字に
u.set.tabstop = 2
u.set.shiftwidth = 0
u.set.softtabstop = 1
-- タブの代わりにスペースを挿入する
u.set.expandtab = true
-- 行末の1文字先までカーソルを移動できるように
u.set.virtualedit = "onemore"
-- 検索文字列入力時に順次対象文字列にヒットさせる
u.set.incsearch = true
-- 検索文字列が小文字の場合は大文字小文字を区別なく検索する
u.set.ignorecase = true
-- 検索時に大文字を含んでいたら大/小を区別
u.set.smartcase = true
-- スクロールした時 常に下に表示するバッファ行の数
u.set.scrolloff = 5
-- 分割方向
u.set.splitright = true
u.set.splitbelow = true

-- 最後に開いていた行を開く
vim.cmd([[
  augroup vimrcEx
    au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
  augroup END
]])

-- 外部からファイルを変更されたら反映する
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

-----------------------------------------------------
-- キーバインド
-----------------------------------------------------
-- プラグインのキーバインドはプラグインの方で行う

-- Hippie completion
if u.is_windows then
  u.key("i", "<S-F6>", "<C-x><C-p>")
else
  u.key("i", "<F18>", "<C-x><C-p>") -- Ubuntu(WSL)ではS-F6がF18となるため
end
-- cnext / cprevious
u.key("n", "<Space>n", ":cnext<CR>", { silent = true })
u.key("n", "<Space>p", ":cprevious<CR>", { silent = true })
-- バッファ切り替え
u.key("n", "<Space>r", ":b#<CR>", { silent = true })
u.key("n", "<Space>e", ":BufferPick<CR>", { silent = true })
u.key("n", "<Space>l", ":BufferNext<CR>", { silent = true })
u.key("n", "<Space>h", ":BufferPrevious<CR>", { silent = true })
u.key("n", "<Space>q", ":Bdelete<CR>", { silent = true })
u.key("n", "<Space>t", ":BufferRestore<CR>", { silent = true })
u.key("n", "<Space>c", ":BufferCloseAllButVisible<CR>", { silent = true })
-- windows split
u.key("n", "<C-w><F12>", ":vsplit<CR>", { silent = true })
