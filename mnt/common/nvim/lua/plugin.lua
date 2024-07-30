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

local neovim_plugins = {
  ----------------------------
  -- 開発/IDE化 (補完系)
  ----------------------------
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
  require("plugins.conform"),
  require("plugins.lspsaga"),
  "j-hui/fidget.nvim",
  require("plugins.lsp_signature"),
  -- インデント
  require("plugins.nvim-autopairs"),
  -- init.lua用
  "folke/neodev.nvim",

  ----------------------------
  -- 開発/IDE化 (補完系以外)
  ----------------------------
  -- Markdown browser preview
  require("plugins.markdown-preview"),
  -- Git
  require("plugins.lazygit"), -- クライアント
  require("plugins.gitsigns"), -- 行表示
  require("plugins.blame"),
  -- シンタックスハイライト
  require("plugins.nvim-treesitter"),
  -- クラスや関数名の固定表示
  "nvim-treesitter/nvim-treesitter-context",
  -- Fuzzy finder
  require("plugins.telescope"),
  require("plugins.smart-open"),
  -- コメントアウト. Neovim 0.10で不要になるかと思いきやVueファイルのようなblockでは対応不十分だったので
  require("plugins.comment"),
  -- アウトラインの表示
  require("plugins.aerial"),
  -- 折り畳み
  require("plugins.nvim-ufo"),
  -- エクスプローラー
  require("plugins.oil"),
  -- ターミナル
  require("plugins.toggleterm"),
  -- バッファタブ
  require("plugins.barbar"),
  -- IDEのような見やすいリスト表示 (diagnostic, references)
  require("plugins.trouble"),

  ----------------------------
  -- エディタの見た目
  ----------------------------
  -- テーマ
  "folke/tokyonight.nvim",
  -- TODO系のコマンドを目立たせる
  require("plugins.todo-comments"),
  -- バッファ削除のときにレイアウトを変更しない
  "famiu/bufdelete.nvim",
  -- カラーコードの表示
  require("plugins.nvim-highlight-colors"),
  -- ステータスライン
  require("plugins.lualine"),
  -- 検索結果の詳細表示
  require("plugins.nvim-hlslens"),
  -- スクロールバー表示
  require("plugins.nvim-scrollbar"),
  -- 通知とコマンドラインを強化
  require("plugins.noice"),
  -- 横幅最適化
  require("plugins.no-neck-pain"),
  -- Markdown preview
  require("plugins.markdown"), -- inline

  -- CSVシンタックス強化
  require("plugins.rainbow_csv"),
  -- マークの可視化
  "kshenoy/vim-signature",
  -- カレントシンボルの強調
  require("plugins.vim-illuminate"),

  ----------------------------
  -- エディタの操作性向上
  ----------------------------
  -- 画面内瞬間移動
  require("plugins.flash"),
  -- quickfix強化(previewなど)
  require("plugins.nvim-bqf"),
  -- 囲まれているものの操作
  require("plugins.nvim-surround"),
  -- アフタリスクコマンド改善
  "rapan931/lasterisk.nvim",
  -- 1行ラインを分割
  require("plugins.treesj"),
  -- タグを自動で閉じる
  require("plugins.nvim-ts-autotag"),

  -- キャメルケースモーション
  require("plugins.CamelCaseMotion"),
  -- ブラックホールレジスト+putの省略
  require("plugins.ReplaceWithRegister"),
  -- テーブル編集
  require("plugins.vim-table-mode"),
  -- 様々なrepeat処理に対応
  "tpope/vim-repeat",
  -- text-object(2)
  "kana/vim-textobj-user", -- ユーザーカスタマイズベース
  require("plugins.vim-textobj-entire"), -- ファイル全体
  -- case変換
  require("plugins.text-case"),
  -- Markdownのリスト変換強化
  require("plugins.markdown-toggle"),
  -- ウィンドウの最大化切り替え
  require("plugins.windows"),
  -- セッションの保存・復元
  require("plugins.resession"),

  ----------------------------
  -- その他
  ----------------------------
  require("plugins.gitlinker"),
  require("plugins.screenkey"),
  -- オリジナル
  require("plugins.ghostwriter"),
}

require("lazy").setup(neovim_plugins)

vim.cmd("colorscheme tokyonight")
