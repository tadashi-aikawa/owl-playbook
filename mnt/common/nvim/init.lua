function merge_tables(t1, t2)
    local merged = {}
    for _, v in ipairs(t1) do
        table.insert(merged, v)
    end
    for _, v in ipairs(t2) do
        table.insert(merged, v)
    end
    return merged
end

local path_sep = package.config:sub(1,1)
local is_windows = path_sep == '\\'
local is_vscode = vim.g.vscode == 1

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

-- VSCode/Neovimのどちらでも使うプラグイン
local common_plugins = {
  -- 'kana/vim-textobj-entire', -- 全体が範囲のtext-object / エラーになる

  'tpope/vim-commentary', -- コメントアウト
  'kana/vim-textobj-user', -- text-objectのユーザーカスタマイズ

  -- 画面内瞬間移動
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    keys = {
      { 's', ':HopChar2<CR>' },
      {
        '<C-l>', function()
          vim.cmd("HopChar1")
          if not is_vscode then
            vim.cmd("call CocAction('jumpDefinition')")
          end
        end
      }
    },
    config = function()
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },

  -- ブラックホールレジスト+putの省略
  {
    'vim-scripts/ReplaceWithRegister',
    keys = {
      {'_', '<Plug>ReplaceWithRegisterOperator'}
    }
  },

  -- 囲まれているものの操作
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup()
    end
  },

  -- キャメルケースモーション
  {
    'bkad/CamelCaseMotion',
    init = function()
      vim.g.camelcasemotion_key = "]"
    end
  },

  -- yankハイライト
  {
    'machakann/vim-highlightedyank',
    config = function()
      vim.g.highlightedyank_highlight_duration = 300
    end
  },
}

-- VSCodeだけで使うプラグイン
local vscode_plugins = {
}

-- Neovimだけで使うプラグイン
local neovim_plugins = {
  'ellisonleao/gruvbox.nvim', -- テーマ
  'sainnhe/gruvbox-material', -- テーマ
  'kshenoy/vim-signature', -- マークの可視化
  'nvim-tree/nvim-web-devicons', -- アイコンの表示
  'famiu/bufdelete.nvim', -- バッファ削除のときにレイアウトを変更しない

  -- シンタックスハイライト
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
          "elixir",
          "lua",
          "bash",
          "html",
          "css",
          "vue",
          "vim",
          "yaml",
          "toml",
          "json",
          "dockerfile",
          "markdown",
          "diff",
          "gitignore"
        },
        highlight = {
          enable = true,
          disable = { "ini" }
        },
      }
    end
  },

  -- バッファ・タブバーをかっこよく
  {
    'romgrk/barbar.nvim',
    dependencies = {'nvim-web-devicons'},
    event = {'BufNewFile', 'BufRead'},
    opts = {
      animation = false,
      sidebar_filetypes = {
        NvimTree = true
      }
    }
  },

  -- ステータスライン
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-web-devicons', opt = true },
    event = {'BufNewFile', 'BufRead'},
    options = { theme = 'gruvbox-material' },
    config = function()
      local lualine = require('lualine')
      local config = {
        options = {
          component_separators = {},
          section_separators = {},
        },
        sections = {
          lualine_a = {'filename'},
          lualine_b = {
            'branch',
            {
              'diff',
              symbols = {added = ' ', modified = ' ', removed = ' '},
            },
          },
          lualine_c = {
            "'%='",
            {
              'diagnostics',
              symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
            },
          },
          lualine_x = {'encoding', 'fileformat'},
          lualine_y = {'filetype','searchcount'},
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      }
      lualine.setup(config)
    end
  },

  -- マルチカーソル
  {
    'mg979/vim-visual-multi',
    init = function()
      t = {}
      t["Find Under"] = "<C-k>"
      t["Find Subword Under"] = "<C-k>"
      vim.g.VM_maps = t
    end
  },

  -- セッション保存
  {
    'jedrzejboczar/possession.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', "nvim-telescope/telescope-frecency.nvim", "kkharji/sqlite.lua" },
    keys = {
      { '<C-j>f', ':Telescope find_files find_command=rg,--files,--hidden,--glob,!*.git <CR>' },
      { '<C-j>z', ':Telescope frecency<CR>' },
      { '<C-j>e', ':Telescope oldfiles<CR>' },
      { '<C-j>g', ':Telescope live_grep<CR>' },
      { '<C-j>l', ':Telescope current_buffer_fuzzy_find<CR>' },
      { '<C-j>p', ':Telescope commands<CR>' },
      { '<C-j>:', ':Telescope command_history<CR>' },
      { '<C-j>m', ':Telescope marks<CR>' }
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

      if is_windows then
        local home = os.getenv("USERPROFILE")
        vim.g.sqlite_clib_path = home .. "/lib/sqlite3.dll"
      else
        vim.g.sqlite_clib_path = "/usr/lib/x86_64-linux-gnu/libsqlite3.so"
      end

      require("telescope").load_extension("frecency")
      require("telescope").load_extension("file_browser")
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
      require("nvim-tree").setup {
        on_attach = function(bufnr)
          local api = require "nvim-tree.api"
          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          api.config.mappings.default_on_attach(bufnr)
          -- ここからカスタマイズhotkeys
          key('n', '?', api.tree.toggle_help, opts('Help'))
          key('n', '<Space>-', api.node.open.horizontal, opts('Open horizontal'))
          key('n', '<Space>i', api.node.open.vertical, opts('Open vertical'))
        end
      }
    end
  },

  -- Fuzzyエクスプローラー
  {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      keys = {
        { '<C-j>r', ":Telescope file_browser path=%:p:h<CR>" }
      }
  },

  -- Git操作
  {
    "is0n/fm-nvim",
    keys = {
      { '<Space>g', ':Gitui<CR>' },
    },
    config = function()
      require('fm-nvim').setup{
        ui = {
          float = {
            height = 0.97,
            width = 0.97,
          }
        }
      }
    end
  },

  -- Gitの行表示
  {
    'lewis6991/gitsigns.nvim',
    event = {'VeryLazy' },
    keys = {
      { '<Space>d', ':Gitsigns preview_hunk<CR>' },
      { '<C-j>D', ':Gitsigns diffthis<CR>' },
      { '<C-j>u', ':Gitsigns reset_hunk<CR>' },
      { '<Space>s', ':Gitsigns stage_hunk<CR>' },
      { '<Space>j', ':Gitsigns next_hunk<CR>' },
      { '<Space>k', ':Gitsigns prev_hunk<CR>' },
    },
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = { text = '' },
          change       = { text = '' },
          delete       = { text = '' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
      }
    end
  },

  -- VSCode like
  {
    'neoclide/coc.nvim',
    branch = "release",
    event = {'BufNewFile', 'BufRead'},
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
        "coc-deno",
        "coc-css",
        "coc-yaml",
        "coc-rust-analyzer",
        "coc-sh",
        "coc-go",
        "coc-prettier",
        "coc-pyright",
        "coc-elixir",
        "coc-java",
        "@yaegassy/coc-volar"
      }
    end
  },

  -- Markdown preview
  {
      "iamcco/markdown-preview.nvim",
      lazy = false,
      keys = {
        { '<M-p>', ':MarkdownPreviewToggle<CR>' }
      },
      build = function() vim.fn["mkdp#util#install"]() end,
  }
}

require('lazy').setup(
  merge_tables(common_plugins, is_vscode and vscode_plugins or neovim_plugins)
)


-----------------------------------------------------
-- 見た目
-----------------------------------------------------
-- Color scheme
set.termguicolors = true
set.syntax = 'on'
if not is_vscode then
  vim.cmd('colorscheme gruvbox-material')
end
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
if is_vscode then
  key('n', '<Space>c', ":call VSCodeNotify('workbench.action.closeOtherEditors')<CR>")
  key('n', '<Space>j', ":call VSCodeNotify('workbench.action.editor.nextChange')<CR>")
  key('n', '<Space>k', ":call VSCodeNotify('workbench.action.editor.previousChange')<CR>")
  key('n', '<Space>d', ":call VSCodeNotify('editor.action.dirtydiff.next')<CR>")
  key('n', '<Space>q', ":call VSCodeNotify('workbench.action.closeActiveEditor')<CR>")
  key('n', '<Space>t', ":call VSCodeNotify('workbench.action.reopenClosedEditor')<CR>")
  key('n', '<Space>h', ":call VSCodeNotify('workbench.action.previousEditor')<CR>")
  key('n', '<Space>l', ":call VSCodeNotify('workbench.action.nextEditor')<CR>")
  key('n', '<Space>r', ":call VSCodeNotify('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')<CR>")
else
  key('n', '<Space>r', ':b#<CR>')
  key('n', '<Space>e', ':BufferPick<CR>')
  key('n', '<Space>l', ':BufferNext<CR>')
  key('n', '<Space>h', ':BufferPrevious<CR>')
  key('n', '<Space>q', ":Bdelete<CR>")
  key('n', '<Space>t', ":BufferRestore<CR>")
  key('n', '<Space>c', ":BufferCloseAllButVisible<CR>")
end

-----------------------------------------------------
-- 状態を保存して終了するRestartコマンド
-- https://zenn.dev/nazo6/articles/neovim-restart-command
-----------------------------------------------------
local restart_cmd = nil

if vim.g.neovide then
  if vim.fn.has "wsl" == 1 then
    restart_cmd = "silent! !nohup neovide.exe --wsl &"
  else
    restart_cmd = "silent! !neovide.exe"
  end
elseif vim.g.fvim_loaded then
  if vim.fn.has "wsl" == 1 then
    restart_cmd = "silent! !nohup fvim.exe &"
  else
    restart_cmd = [=[silent! !powershell -Command "Start-Process -FilePath fvim.exe"]=]
  end
end

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

if is_windows then
  -- do nothing
else
  require('clipboard')
end
