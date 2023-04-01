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
-- 改行コード自動判別
set.fileformats="unix,dos,mac"
-- swapfileを作成しない
vim.opt.swapfile = false

-----------------------------------------------------
--  プラグイン
-----------------------------------------------------

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

require("lazy").setup({
  'ellisonleao/gruvbox.nvim',
  'sainnhe/gruvbox-material',
  'tpope/vim-commentary', -- コメントアウト
  'kana/vim-textobj-user', -- text-objectのユーザーカスタマイズ
  -- 'kana/vim-textobj-entire', -- 全体が範囲のtext-object / エラーになる
  'kshenoy/vim-signature', -- マークの可視化
  'nvim-tree/nvim-web-devicons', -- アイコンの表示
  {
    'nvim-treesitter/nvim-treesitter',
    event = {'BufNewFile', 'BufRead'},
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "typescript",
          "javascript",
          "rust",
          "python",
          "go",
          "lua",
          "bash",
          "html",
          "css",
          "vue",
          "vim",
          "yaml",
          "toml",
          "ini",
          "json",
          "dockerfile",
          "markdown",
          "diff",
          "gitignore"
        },
        highlight = {
          enable = true,
        },
      }
    end
  },
  -- ブラックホールレジスト+putの省略
  {
    'vim-scripts/ReplaceWithRegister',
    keys = {
      {'_', '<Plug>ReplaceWithRegisterOperator'}
    }
  },
  -- バッファ・タブバーをかっこよく
  {
    'romgrk/barbar.nvim',
    dependencies = {'nvim-web-devicons'},
    event = {'BufNewFile', 'BufRead'},
  }, 
  -- 囲まれているものの操作
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  -- キャメルケースモーション
  {
    'bkad/CamelCaseMotion',
    config = function()
      vim.g.camelcasemotion_key = "]"
    end
  },
  -- 画面内瞬間移動
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    keys = {
      { 's', ':HopChar2MW<CR>' }
    },
    config = function()
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },
  -- yankハイライト
  {
    'machakann/vim-highlightedyank',
    config = function()
      vim.g.highlightedyank_highlight_duration = 300
    end
  },
  -- マルチカーソル
  {
    'mg979/vim-visual-multi',
    init = function()
      t = {}
      t["Find Under"] = "<C-k>"
      vim.g.VM_maps = t
    end
  },
  -- ステータスライン
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-web-devicons', opt = true },
    event = {'BufNewFile', 'BufRead'},
    options = { theme = 'gruvbox-material' },
    config = 'require("lualine").setup()'
  },
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim', "nvim-telescope/telescope-frecency.nvim", "kkharji/sqlite.lua" },
    keys = {
      { '<C-j>f', ':Telescope find_files find_command=rg,--files,--hidden,--glob,!*.git <CR>' },
      { '<C-j>e', ':Telescope frecency<CR>' },
      { '<C-j>g', ':Telescope live_grep<CR>' },
      { '<C-j>l', ':Telescope current_buffer_fuzzy_find<CR>' }
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup {
          defaults = {
              mappings = {
                  i = {
                    ["<esc>"] = actions.close,
                    ["<F12>"] = actions.select_vertical,
                  },
                  n = { ["q"] = actions.close },
              },
              layout_strategy = 'vertical'
          },
          extensions = {
            frecency = {
              show_scores = true
            }
          }
      }
      require("telescope").load_extension("frecency")


      local home = os.getenv("USERPROFILE")
      vim.g.sqlite_clib_path = home .. "/lib/sqlite3.dll"
    end
  },
  -- エクスプローラー
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    keys = {
      { '<M-w>', ':NvimTreeToggle<CR>' },
      { '<C-j>w', ':NvimTreeFindFile<CR>' }
    },
    config = function()
      require("nvim-tree").setup()
    end
  },
  -- Gitの行表示
  {
    'lewis6991/gitsigns.nvim',
    event = {'BufNewFile', 'BufRead'},
    keys = {
      { '<C-j>d', ':Gitsigns preview_hunk<CR>' },
      { '<C-j>D', ':Gitsigns diffthis<CR>' },
      { '<C-j><C-u>', ':Gitsigns reset_hunk<CR>' },
      { '<Space>s', ':Gitsigns stage_hunk<CR>' },
      { '<Space>j', ':Gitsigns next_hunk<CR>' },
      { '<Space>k', ':Gitsigns prev_hunk<CR>' },
    },
    config = function()
      require('gitsigns').setup()
    end
  },
  -- VSCode like
  {
    'neoclide/coc.nvim',
    branch = "release",
    event = "InsertEnter",
    keys = {
      -- 定義に移動
      { '<C-]>', '<Plug>(coc-definition)' },
      -- 呼び出し元に移動
      { '<C-j>h', '<Plug>(coc-references)' },
      -- 実装に移動
      { '<C-j>i', '<Plug>(coc-implementation)' },
      -- 配下の定義を表示
      { '<M-s>', ':call CocActionAsync(\'doHover\')<CR>' },
      { '<C-P>', '<C-\\><C-O>:call CocActionAsync(\'showSignatureHelp\')<CR>', mode = "i" },
      -- 前後のエラーや警告に移動
      { '<M-k>', '<Plug>(coc-diagnostic-prev)' },
      { '<M-j>', '<Plug>(coc-diagnostic-next)' },
      -- Enterキーで決定
      { "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], mode = "i", expr = true, replace_keycodes = false },
      -- 上下で候補選択
      { "<down>", [[coc#pum#visible() ? coc#pum#next(1) : "<down>"]], mode = "i", expr = true, replace_keycodes = false },
      { "<up>", [[coc#pum#visible() ? coc#pum#prev(1): "<up>"]], mode = "i", expr = true, replace_keycodes = false },
      -- code action
      { '<M-CR>', '<Plug>(coc-codeaction-cursor)' },
      -- Find symbol of current document
      { '<C-j>o', ':<C-u>CocList outline<cr>' },
      -- Search workspace symbols
      { '<C-j>s', ':<C-u>CocList -I symbols<cr>' },
      -- Rename
      { '<S-M-r>', '<Plug>(coc-rename)' },
      -- Auto complete
      { "<F5>", [[coc#refresh()]], mode = "i", expr = true },
    },
    config = function()
      vim.g.coc_global_extensions = {
        "coc-json",
        "coc-tsserver",
        "coc-css",
        "coc-yaml",
        "coc-rust-analyzer",
        "coc-sh",
        "coc-prettier",
        "coc-pyright",
        "@yaegassy/coc-volar"
      }
    end
  },
  -- Markdown preview
  {
      "iamcco/markdown-preview.nvim",
      keys = {
        { '<M-p>', ':MarkdownPreviewToggle<CR>' }
      },
      build = function() vim.fn["mkdp#util#install"]() end,
  }
})

-----------------------------------------------------
-- 見た目
-----------------------------------------------------
-- Color scheme
set.termguicolors = true
set.syntax = 'on'
vim.cmd('colorscheme gruvbox-material')
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
-- ターミナル
-----------------------------------------------------
vim.opt.shell = "pwsh"
key('n', '<C-j>t', ':split | wincmd j | resize 15 | terminal<CR>i', { noremap = true })
key('t', '<ESC>', '<C-\\><C-n>', { noremap = true }) -- ESCでノーマルモード

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

