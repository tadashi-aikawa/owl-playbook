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
  -- 全体
  ---------------------

  -- テーマ(2)
  'ellisonleao/gruvbox.nvim',
  'sainnhe/gruvbox-material',
  -- バッファ削除のときにレイアウトを変更しない
  'famiu/bufdelete.nvim',
  -- セッション保存
  require("plugins.possession"),
  -- TUIツール
  require("plugins.fm-nvim"),

  ---------------------
  -- Vim like
  ---------------------

  -- text-object(2)
  'kana/vim-textobj-user',               -- ユーザーカスタマイズベース
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
  'tpope/vim-repeat',
  -- quickfix強化(previewなど)
  'kevinhwang91/nvim-bqf',
  -- スムーズなスクロール
  require("plugins.neoscroll"),
  -- mini.nvim
  require("plugins.mini"),
  -- 現在行にカーソルを表示し、一定以上移動したらアニメーションで追従する
  require("plugins.SmoothCursor"),
  -- TODO系のコマンドを目立たせる --
  require("plugins.todo-comments"),

  ---------------------
  -- to be IDE
  ---------------------

  -- VSCode like
  require("plugins.coc"),
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
  'kshenoy/vim-signature',
  -- アイコンの表示
  'nvim-tree/nvim-web-devicons',
  -- 通知とコマンドラインを強化
  require("plugins.noice"),
  -- コメントアウト(2)
  'JoosepAlviste/nvim-ts-context-commentstring', -- vue.jsなどの特殊なケース用
  require("plugins.nvim-comment"),
  -- HTMLの閉じタグ補完
  'windwp/nvim-ts-autotag',
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
}

require('lazy').setup(
  neovim_plugins
)

vim.cmd('colorscheme gruvbox-material')
