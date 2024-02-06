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
  ---------------------
  -- Vim like
  ---------------------

  -- text-object(2)
  "kana/vim-textobj-user", -- ユーザーカスタマイズベース
  require("plugins.vim-textobj-entire"), -- ファイル全体
  -- 画面内瞬間移動
  require("plugins.leap"),
  -- fコマンドの強化
  require("plugins.flit"),
  -- ブラックホールレジスト+putの省略
  require("plugins.ReplaceWithRegister"),
  -- 囲まれているものの操作
  require("plugins.nvim-surround"),
  -- キャメルケースモーション
  require("plugins.CamelCaseMotion"),
  -- 様々なrepeat処理に対応
  "tpope/vim-repeat",
  -- quickfix強化(previewなど)
  "kevinhwang91/nvim-bqf",
  -- スムーズなスクロール
  require("plugins.neoscroll"),
  -- mini.nvim
  require("plugins.mini"),
  -- TODO系のコマンドを目立たせる --
  require("plugins.todo-comments"),

  ---------------------
  -- to be IDE
  ---------------------

  -- VSCode like
  -- require("plugins.coc"),
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
  -- シンタックスハイライト
  require("plugins.nvim-treesitter"),
  -- Fuzzy finder
  require("plugins.telescope"),
  -- エクスプローラー
  require("plugins.nvim-tree"),
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
  -- マルチカーソル
  require("plugins.vim-visual-multi"),
  -- スクロールバー表示
  require("plugins.nvim-scrollbar"),
  -- Gitの行表示
  require("plugins.gitsigns"),
  -- Git blame
  "FabijanZulj/blame.nvim",
  -- Gitの行履歴詳細表示
  require("plugins.git-messenger"),
  -- マークの可視化
  "kshenoy/vim-signature",
  -- アイコンの表示
  "nvim-tree/nvim-web-devicons",
  -- 通知とコマンドラインを強化
  require("plugins.noice"),
  -- コメントアウト(2)
  "JoosepAlviste/nvim-ts-context-commentstring", -- vue.jsなどの特殊なケース用
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
  -- Swagger UI preview
  require("plugins.swagger-preview"),

  ---------------------
  -- 全体
  ---------------------

  -- バッファ削除のときにレイアウトを変更しない
  "famiu/bufdelete.nvim",
  -- セッション保存
  require("plugins.possession"),
  -- Git
  require("plugins.lazygit"),
  -- テーマ(2)
  -- 'ellisonleao/gruvbox.nvim',
  -- 'sainnhe/gruvbox-material',
  -- 'EdenEast/nightfox.nvim',
  "folke/tokyonight.nvim",
}

require("lazy").setup(neovim_plugins)

vim.cmd("colorscheme tokyonight")
