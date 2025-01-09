local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  diff = { cmd = "terminal_git" },
  change_detection = {
    notify = false,
  },
})

vim.cmd([[colorscheme tokyonight]])

vim.opt.swapfile = false -- swapfileを作成しない
vim.opt.number = true -- 行番号の表示
vim.opt.clipboard = "unnamedplus" -- クリップボードとヤンクの同期
vim.opt.tabstop = 2 -- タブの文字数指定 -- 好みで2 or 4
vim.opt.shiftwidth = 0 -- インデントの幅 -- 0でtabstopの値(2)を使う
vim.opt.expandtab = true -- タブをスペースとして入力する
vim.opt.ignorecase = true -- 検索文字列が小文字の場合は大文字小文字を区別なく検索する
vim.opt.smartcase = true -- 検索時に大文字を含んでいたら大/小を区別
vim.opt.cursorline = true -- カーソル行の表示を強調

-- Yankした範囲を反転色でハイライト
vim.api.nvim_set_hl(0, "YankHighlight", { reverse = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 })
  end,
})
