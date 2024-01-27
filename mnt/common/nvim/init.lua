local path_sep = package.config:sub(1, 1)
local is_windows = path_sep == '\\'
local set = vim.opt
local key = vim.keymap.set

-- For nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-----------------------------------------------------
--  全体
-----------------------------------------------------
-- 文字コード自動判別
set.encoding = "utf-8"
set.fileencodings = "utf-8,sjis"
-- 改行コード自動判別
set.fileformats = "unix,dos,mac"
-- swapfileを作成しない
vim.opt.swapfile = false
-- colorizerプラグインで必要
set.termguicolors = true

require("plugin")

-----------------------------------------------------
-- 操作
-----------------------------------------------------

-- バッファを未保存でも閉じる
set.hidden = true
-- バックスペースの有効化
set.backspace = 'indent,eol,start'
-- コマンドのタイムラグをなくす
set.ttimeoutlen = 1
-- タブを基本2文字に
set.smarttab = true
set.tabstop = 2
set.shiftwidth = 2
-- タブの代わりにスペースを挿入する
set.expandtab = true
-- 1行前のインデントを考慮してインデントする
set.autoindent = true
-- スマートなインデント (Cとかでなければ必要ない??)
set.smartindent = true
-- 行末の1文字先までカーソルを移動できるように
set.virtualedit = 'onemore'
-- 検索文字列入力時に順次対象文字列にヒットさせる
set.incsearch = true
-- 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set.ignorecase = true
-- 検索時に大文字を含んでいたら大/小を区別
set.smartcase = true
-- Clipboard magic?
if is_windows then
  set.clipboard = 'unnamed'
else
  set.clipboard = 'unnamedplus'
end
-- スクロールした時 常に下に表示するバッファ行の数
set.scrolloff = 5

-- 最後に開いていた行を開く
vim.cmd([[
  augroup vimrcEx
    au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
  augroup END
]])


-----------------------------------------------------
-- ターミナル
-----------------------------------------------------
if is_windows then
  vim.opt.shell = "pwsh"
  -- https://github.com/neovim/neovim/issues/13893
  vim.opt.shellcmdflag = '-nologo -noprofile -ExecutionPolicy RemoteSigned -command'
  vim.opt.shellxquote = ''
end

key('n', '<C-j>t', ':split | wincmd j | resize 15 | terminal<CR>i', { noremap = true, silent = true })
key('t', '<ESC>', '<C-\\><C-n>', { noremap = true, silent = true }) -- ESCでノーマルモード

-----------------------------------------------------
-- キーバインド
-----------------------------------------------------
-- Hippie completion
if is_windows then
  key('i', '<S-F6>', '<C-x><C-p>')
else
  key('i', '<F18>', '<C-x><C-p>') -- Ubuntu(WSL)ではS-F6がF18となるため
end
-- 行オートコンプリート
key('i', '<C-l>', '<C-x><C-l>')
-- cnext / cprevious
key('n', '<Space>n', ':cnext<CR>', { silent = true })
key('n', '<Space>p', ':cprevious<CR>', { silent = true })
-- バッファ切り替え
key('n', '<Space>r', ':b#<CR>', { silent = true })
key('n', '<Space>e', ':BufferPick<CR>', { silent = true })
key('n', '<Space>l', ':BufferNext<CR>', { silent = true })
key('n', '<Space>h', ':BufferPrevious<CR>', { silent = true })
key('n', '<Space>q', ":Bdelete<CR>", { silent = true })
key('n', '<Space>t', ":BufferRestore<CR>", { silent = true })
key('n', '<Space>c', ":BufferCloseAllButVisible<CR>", { silent = true })

-----------------------------------------------------
-- 状態を保存して終了するRestartコマンド
-- https://zenn.dev/nazo6/articles/neovim-restart-command
-----------------------------------------------------
local restart_cmd = nil

vim.api.nvim_create_user_command("Restart", function()
  if vim.fn.has "gui_running" then
    if restart_cmd == nil then
      vim.notify("Restart command not found", vim.log.levels.WARN)
    end
  end

  require("possession.session").save("restart", { no_confirm = true })
  vim.cmd [[silent! bufdo bwipeout]]

  vim.g.NVIM_RESTARTING = true

  if restart_cmd then
    vim.cmd(restart_cmd)
  end

  vim.cmd [[qa!]]
end, {})

-----------------------------------------------------
-- 見た目
-----------------------------------------------------
-- Color scheme
set.background = 'dark'

-- 行番号の表示
set.number = true

-- Highlight
vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#885522" })
vim.api.nvim_set_hl(0, 'Visual', { bg = "#661111" })
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#121212", bg = "#EE9999" })

-- ステータスバーは分割しない
set.laststatus = 3

-- coc-highlightの表示を早めるために4000msから短くする
set.updatetime = 200

-----------------------------------------------------
-- autocmd
-----------------------------------------------------

-- Restartコマンドで現状を維持したまま再起動するのに必要 (他にも設定箇所あり)
vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    if vim.g.NVIM_RESTARTING then
      vim.g.NVIM_RESTARTING = false
      require("possession.session").load "restart"
      require("possession.session").delete("restart", { no_confirm = true })
      vim.opt.cmdheight = 1
    end
  end,
})

-- Git statusに変更があったときにNvimtreeの表示を変更させるために必要
vim.api.nvim_create_autocmd("User", {
  pattern = "NeogitStatusRefreshed",
  command = ":NvimTreeRefresh<CR>"
})

-- Yankした範囲をハイライトさせる
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 200 })
  end,
})

-----------------------------------------------------
-- Clipboard
-----------------------------------------------------

if not is_windows then
  require('clipboard')
end
