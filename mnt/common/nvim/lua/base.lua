vim.opt.termguicolors = true

-- 挨拶メッセージを非表示
vim.opt.shortmess:append("I")

-----------------------------------------------------
-- 挙動
-----------------------------------------------------

-- 文字コード自動判別
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "utf-8,sjis"
-- 改行コード自動判別
vim.opt.fileformats = "unix,dos,mac"
-- swapfileを作成しない
vim.opt.swapfile = false

-- バッファを未保存でも閉じる
vim.opt.hidden = true
-- バックスペースの有効化
vim.opt.backspace = "indent,eol,start"
-- タブを基本2文字に
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.softtabstop = 1
-- タブの代わりにスペースを挿入する
vim.opt.expandtab = true
-- 行末の1文字先までカーソルを移動できるように
vim.opt.virtualedit = "onemore"
-- 検索文字列入力時に順次対象文字列にヒットさせる
vim.opt.incsearch = true
-- 検索文字列が小文字の場合は大文字小文字を区別なく検索する
vim.opt.ignorecase = true
-- 検索時に大文字を含んでいたら大/小を区別
vim.opt.smartcase = true
-- スクロールした時 常に下に表示するバッファ行の数
vim.opt.scrolloff = 5
-- 分割方向
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 最後に開いていた行を開く
vim.cmd([[
  augroup vimrcEx
    au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
  augroup END
]])

-- 外部からファイルを変更されたら反映する
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  pattern = "*",
  command = "checktime",
})
