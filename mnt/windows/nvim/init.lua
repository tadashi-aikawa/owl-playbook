local set = vim.opt
local key = vim.keymap.set

-----------------------------------------------------
--  全体
-----------------------------------------------------
-- 文字コード自動判別
set.encoding = "utf-8"
-- 改行コード自動判別
set.fileformats="unix,dos,mac"
-- swapfileを作成しない
vim.opt.swapfile = false

-----------------------------------------------------
--  プラグイン
-----------------------------------------------------
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' 
  use 'morhetz/gruvbox' -- テーマ
  use 'vim-scripts/ReplaceWithRegister' -- ブラックホールレジスト+putの省略
  use 'tpope/vim-commentary' -- コメントアウト
  use 'kana/vim-textobj-user' -- text-objectのユーザーカスタマイズ
  use 'kana/vim-textobj-entire' -- 全体が範囲のtext-object
  use 'kshenoy/vim-signature' -- マークの可視化
  use 'nvim-tree/nvim-web-devicons' -- アイコンの表示
  use {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'} -- バッファ・タブバーをかっこよく
  -- 囲まれているものの操作
  use {
    'machakann/vim-sandwich',
    config = 'vim.cmd("runtime macros/sandwich/keymap/surround.vim")'
  }
  -- キャメルケースモーション
  use {
    'bkad/CamelCaseMotion',
    config = 'vim.g.camelcasemotion_key = "]"'
  }
  -- 画面内瞬間移動
  use {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }
  use {
    'machakann/vim-highlightedyank',
    config = 'vim.g.highlightedyank_highlight_duration = 300'
  }
  -- マルチカーソル
  use {
    'mg979/vim-visual-multi',
    config = function()
      vim.api.nvim_command('let g:VM_maps = {}')
      vim.api.nvim_command("let g:VM_maps['Find Under'] = '<C-k>'")
      vim.api.nvim_command("let g:VM_maps['Find Subword Under'] = '<C-k>'")
    end
  }
  -- ステータスライン
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    options = { theme = 'gruvbox' },
    config = 'require("lualine").setup()'
  }
  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup {
          defaults = {
              mappings = {
                  i = { ["<esc>"] = actions.close },
                  n = { ["q"] = actions.close },
              },
              layout_strategy = 'vertical'
          }
      }
    end
  }
  use {
    'nvim-telescope/telescope-frecency.nvim',
    config = function()
      require"telescope".load_extension("frecency")
      local home = os.getenv("USERPROFILE")
      vim.g.sqlite_clib_path = home .. "/lib/sqlite3.dll"
    end,
    requires = {"kkharji/sqlite.lua"}
  }
  -- サイドバー表示 (ファイルの変更、診断、エクスプローラー、symbolなど)
  use {
    'sidebar-nvim/sidebar.nvim',
    config = function()
      require("sidebar-nvim").setup {
        open = true,
        sections = { "git", "diagnostics", "files", "symbols" },
        files = {
          show_hidden = true,
          ignore_paths = {"%.git$"}
        }
      }
      -- hop.nvimでsを使いたいので無効化してaに割り当て
      local git_section = require("sidebar-nvim.builtin.git")
      git_section.bindings["a"] = git_section.bindings["s"]
      git_section.bindings["s"] = nil
    end
  }
  -- Gitの行表示
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
  -- VSCode like
  use {
    'neoclide/coc.nvim',
    branch = "release",
    config = function()
      vim.g.coc_global_extensions = {
        "coc-json",
        "coc-tsserver",
        "coc-css",
        "coc-yaml",
        "coc-rust-analyzer",
        "coc-sh",
        "coc-prettier",
        "coc-pyright"
      }
    end
  }
end)

-----------------------------------------------------
--  プラグインキーバインド
-----------------------------------------------------

--------------
-- coc.nvim --
--------------
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
-- 定義に移動
key('n', '<C-]>', '<Plug>(coc-definition)', {silent = true})
-- 呼び出し元に移動
key('n', '<C-j>h', '<Plug>(coc-references)', {silent = true})
-- 実装に移動
key('n', '<C-j>i', '<Plug>(coc-implementation)', {silent = true})
-- 配下の定義を表示
key('n', '<M-s>', ':call CocActionAsync(\'doHover\')<CR>', {silent = true, noremap = true})
key('i', '<C-P>', '<C-\\><C-O>:call CocActionAsync(\'showSignatureHelp\')<CR>', {silent = true})
-- 前後のエラーや警告に移動
key('n', '<M-k>', '<Plug>(coc-diagnostic-prev)', {silent = true})
key('n', '<M-j>', '<Plug>(coc-diagnostic-next)', {silent = true})
-- Enterキーで決定
key("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
-- code action
key('n', '<M-CR>', '<Plug>(coc-codeaction-cursor)', {silent = true})
-- Find symbol of current document
key('n', '<C-j>o', ':<C-u>CocList outline<cr>', {silent = true, nowait = true})
-- Search workspace symbols
key('n', '<C-j>s', ':<C-u>CocList -I symbols<cr>', {silent = true, nowait = true})
-- Rename
key('n', '<S-M-r>', '<Plug>(coc-rename)')

--------------
-- others --
--------------

-- telescope
-- local builtin = require('telescope.builtin')
key('n', '<C-j>f', ':Telescope find_files find_command=rg,--files,--hidden,--glob,!*.git <CR>', {silent = true, noremap = true})
key('n', '<C-j>e', ':Telescope frecency<CR>', {silent = true, noremap = true})
-- gitsigns
key('n', '<C-j>d', ':Gitsigns preview_hunk<CR>', {silent = true, noremap = true})
key('n', '<C-j>D', ':Gitsigns diffthis<CR>', {silent = true, noremap = true})
key('n', '<Space>j', ':Gitsigns next_hunk<CR>', {silent = true, noremap = true})
key('n', '<Space>k', ':Gitsigns prev_hunk<CR>', {silent = true, noremap = true})
-- ReplaceWithRegister
key('n', '_', '<Plug>ReplaceWithRegisterOperator')
-- hop
key('n', 's', ':HopChar2MW<CR>', {silent = true, noremap = true})
-- Sidebar
key('n', '<M-w>', ':SidebarNvimToggle<CR>', {silent = true, noremap = true})

-----------------------------------------------------
-- パフォーマンス
-----------------------------------------------------
-- 無駄な描画をしない
set.lazyredraw = true
-- 再描画の速度が速くなるらしいけど最近の端末では無意味との噂も..
set.ttyfast = true

-----------------------------------------------------
-- 見た目
-----------------------------------------------------
-- Color scheme
set.termguicolors = true
set.syntax = 'on'
vim.cmd('colorscheme gruvbox') -- ★特殊な書き方
set.background = 'dark'

-- 行番号の表示
set.number = true
-- 検索語をハイライト
set.hlsearch = true
-- ステータスラインを常に表示
set.laststatus = 2

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
set.clipboard = 'unnamed'
-- スクロールした時 常に下に表示するバッファ行の数
set.scrolloff = 5

-- 最後に開いていた行を開く
vim.cmd([[
  augroup vimrcEx
    au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
  augroup END
]])


-----------------------------------------------------
-- キーバインド
-----------------------------------------------------
-- 行オートコンプリート
key('i', '<C-l>', '<C-x><C-l>')
-- Escapeでハイライト消去
key('n', '<ESC><ESC>', ':nohl<CR>')
-- バッファ切り替え
key('n', '<Space>r', ':b#<CR>')
key('n', '<Space>e', ':BufferPick<CR>')
key('n', '<Space>l', ':BufferNext<CR>')
key('n', '<Space>h', ':BufferPrevious<CR>')
key('n', '<Space>q', ":bd<CR>")
