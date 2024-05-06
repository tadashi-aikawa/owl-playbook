local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- vim-bookmarksのデフォルトキーマップ無効化
vim.g.bookmark_no_default_key_mappings = 1

local neovim_plugins = {
  ---------------------
  -- Vim like
  ---------------------

  -- text-object(2)
  "kana/vim-textobj-user", -- ユーザーカスタマイズベース
  require("plugins.vim-textobj-entire"), -- ファイル全体
  -- 画面内瞬間移動
  require("plugins.flash"),
  -- ブラックホールレジスト+putの省略
  require("plugins.ReplaceWithRegister"),
  -- 囲まれているものの操作
  require("plugins.nvim-surround"),
  -- キャメルケースモーション
  require("plugins.CamelCaseMotion"),
  -- 様々なrepeat処理に対応
  "tpope/vim-repeat",
  -- quickfix強化(previewなど)
  require("plugins.nvim-bqf"),
  -- quickfixでそのまま一括編集
  require("plugins.replacer"),
  -- TODO系のコマンドを目立たせる --
  require("plugins.todo-comments"),
  -- アフタリスクコマンド改善
  "rapan931/lasterisk.nvim",
  -- ステータスバーをフローティング表示
  require("plugins.incline"),
  -- 1行ラインを分割
  require("plugins.treesj"),

  ---------------------
  -- to be IDE
  ---------------------

  -- LSP
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "onsails/lspkind.nvim",
  "b0o/schemastore.nvim",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  require("plugins.nvim-lspconfig"),
  require("plugins.none-ls"),
  require("plugins.lspsaga"),
  "j-hui/fidget.nvim",
  require("plugins.lsp_signature"),
  -- IDEのような見やすいリスト表示
  require("plugins.trouble"),
  -- シンタックスハイライト
  require("plugins.nvim-treesitter"),
  -- クラスや関数名の固定表示
  "nvim-treesitter/nvim-treesitter-context",
  -- Fuzzy finder
  require("plugins.telescope"),
  require("plugins.smart-open"),
  -- エクスプローラー
  require("plugins.oil"),
  -- バッファ・タブバーをかっこよく
  require("plugins.barbar"),
  -- ステータスライン
  require("plugins.lualine"),
  -- アウトラインの表示
  require("plugins.aerial"),
  -- カレントシンボルの強調
  require("plugins.vim-illuminate"),
  -- インデント
  require("plugins.nvim-autopairs"),
  -- スクロールバー表示
  require("plugins.nvim-scrollbar"),
  -- 折り畳み
  require("plugins.nvim-ufo"),
  -- Gitの行表示
  require("plugins.gitsigns"),
  -- Git blame
  require("plugins.blame"),
  -- Gitの行履歴詳細表示
  require("plugins.git-messenger"),
  -- マークの可視化
  "kshenoy/vim-signature",
  -- 通知とコマンドラインを強化
  require("plugins.noice"),
  -- コメントアウト(2)
  require("plugins.nvim-ts-context-commentstring"),
  require("plugins.nvim-comment"),
  -- カラーコードの表示
  require("plugins.nvim-colorizer"),
  -- CSVシンタックス強化
  require("plugins.rainbow_csv"),
  -- テーブルソート
  require("plugins.vim-table-mode"),
  -- ブックマーク
  require("plugins.vim-bookmarks"),
  -- 検索結果の詳細表示
  require("plugins.nvim-hlslens"),
  -- Markdown preview
  require("plugins.markdown-preview"),
  -- ターミナル
  require("plugins.toggleterm"),

  ---------------------
  -- 全体
  ---------------------

  -- バッファ削除のときにレイアウトを変更しない
  "famiu/bufdelete.nvim",
  -- Git
  require("plugins.lazygit"),
  -- テーマ
  "folke/tokyonight.nvim",
  -- 横幅最適化
  require("plugins.no-neck-pain"),
}

require("lazy").setup(neovim_plugins)

vim.cmd("colorscheme tokyonight")
