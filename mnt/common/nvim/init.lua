local function merge_tables(t1, t2)
  local merged = {}
  for _, v in ipairs(t1) do
    table.insert(merged, v)
  end
  for _, v in ipairs(t2) do
    table.insert(merged, v)
  end
  return merged
end

local path_sep = package.config:sub(1, 1)
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
set.fileencodings = "utf-8,sjis"
-- 改行コード自動判別
set.fileformats = "unix,dos,mac"
-- swapfileを作成しない
vim.opt.swapfile = false
-- colorizerプラグインで必要
set.termguicolors = true

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
  'tpope/vim-commentary',  -- コメントアウト
  'kana/vim-textobj-user', -- text-objectのユーザーカスタマイズ
  -- HTMLの閉じタグ補完
  'windwp/nvim-ts-autotag',

  -- 全体が範囲のtext-object
  {
    'kana/vim-textobj-entire',
    event = { 'BufNewFile', 'BufRead' },
  },

  -- カラーコードの表示
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup()
    end
  },

  -- 画面内瞬間移動
  {
    'ggandor/leap.nvim',
    config = function()
      key('n', 's', function()
        local focusable_windows = vim.tbl_filter(
          function(win) return vim.api.nvim_win_get_config(win).focusable end,
          vim.api.nvim_tabpage_list_wins(0)
        )
        require('leap').leap { target_windows = focusable_windows }
      end)
    end
  },

  -- fコマンドの強化
  {
    'ggandor/flit.nvim',
    config = function()
      require('flit').setup {
        keys = { f = 'f', F = 'F', t = 't', T = 'T' },
        labeled_modes = "v",
        multiline = true,
        opts = {}
      }
    end
  },

  -- ブラックホールレジスト+putの省略
  {
    'vim-scripts/ReplaceWithRegister',
    keys = {
      { '_', '<Plug>ReplaceWithRegisterOperator' }
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
      vim.g.camelcasemotion_key = "["
    end
  },
}

-- VSCodeだけで使うプラグイン
local vscode_plugins = {
  {
    'echasnovski/mini.nvim',
    version = false,
    event = { 'BufNewFile', 'BufRead' },
    config = function()
      require('mini.cursorword').setup()
      vim.cmd [[highlight MiniCursorword guibg=darkcyan guifg=lightgray]]
    end
  },
  -- 検索結果の詳細表示
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      -- scrollbar.handlers.search はエラーになるので
      require('hlslens').setup()
    end
  },
}

-- Neovimだけで使うプラグイン
local neovim_plugins = {
  'ellisonleao/gruvbox.nvim',    -- テーマ
  'sainnhe/gruvbox-material',    -- テーマ
  'kshenoy/vim-signature',       -- マークの可視化
  'nvim-tree/nvim-web-devicons', -- アイコンの表示
  'famiu/bufdelete.nvim',        -- バッファ削除のときにレイアウトを変更しない
  'tpope/vim-repeat',            -- repeat
  'kevinhwang91/nvim-bqf',       -- quickfix強化(previewなど)

  -- CSVシンタックス強化
  {
    'mechatroner/rainbow_csv',
    config = function()
      vim.g.rcsv_colorpairs = {
        { 'red',        'red' },
        { 'yellow',     'yellow' },
        { 'lightgray',  'lightgray' },
        { 'lightgreen', 'lightgreen' },
        { 'lightblue',  'lightblue' },
        { 'cyan',       'cyan' },
        { 'lightred',   'lightred' },
        { 'darkyellow', 'darkyellow' },
        { 'white',      'white' },
      }
    end
  },

  -- テーブルソート
  {
    'dhruvasagar/vim-table-mode',
    config = function()
      vim.api.nvim_set_keymap('n', '<A-;>', "<Cmd>:TableModeRealign<CR>", {})
    end
  },

  -- ブックマーク
  {
    'MattesGroeger/vim-bookmarks',
    config = function()
      vim.g.bookmark_sign            = '󰃀 '
      vim.g.bookmark_annotation_sign = '󱖯 '
    end
  },
  -- 検索結果の詳細表示
  {
    "kevinhwang91/nvim-hlslens",
    event = { 'BufNewFile', 'BufRead' },
    config = function()
      require("scrollbar.handlers.search").setup({
        override_lens = function(render, posList, nearest, idx)
          local text, chunks
          local lnum, col = unpack(posList[idx])
          local cnt = #posList
          text = ('[%d/%d]'):format(idx, cnt)
          if nearest then
            chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
          else
            chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end
      })
      local kopts = { noremap = true, silent = true }

      vim.api.nvim_set_keymap('n', 'n',
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', 'N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

      vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

      vim.cmd [[
        highlight HlSearchLensNear guifg=white guibg=olive
        highlight HlSearchLens guifg=#777777 guibg=#FFFFFFFF
      ]]
    end
  },
  -- スムーズなスクロール
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup {}
    end
  },
  -- スクロールバー表示
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require("scrollbar").setup({
        handle = {
          color = "gray"
        },
        marks = {
          Search = { color = "lime" },
          Error = { color = "red" },
          Warn = { color = "orange" },
          Info = { color = "cyan" },
          Hint = { color = "gray" },
          Misc = { color = "purple" },
        }
      })
    end
  },

  -- シンタックスハイライト
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufNewFile', 'BufRead' },
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "bash",
          "css",
          "diff",
          "dockerfile",
          "elixir",
          "gitignore",
          "go",
          "html",
          "http",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "rust",
          "svelte",
          "toml",
          "typescript",
          "vim",
          "vue",
          "yaml",
        },
        highlight = {
          enable = true,
          disable = { "ini" }
        },
        autotag = {
          enable = true,
        },
        -- texobjectsはパフォーマンスの問題から利用しない
      }
    end
  },

  -- バッファ・タブバーをかっこよく
  {
    'romgrk/barbar.nvim',
    dependencies = { 'nvim-web-devicons' },
    event = { 'BufNewFile', 'BufRead' },
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
    event = { 'BufNewFile', 'BufRead' },
    options = { theme = 'gruvbox-material' },
    config = function()
      local lualine = require('lualine')
      local config = {
        options = {
          component_separators = {},
          section_separators = {},
        },
        sections = {
          lualine_a = {
            'branch',
            {
              'diff',
              symbols = { added = ' ', modified = ' ', removed = ' ' },
            },
          },
          lualine_b = { { 'filename', path = 1 }, 'aerial' },
          lualine_c = {
            "'%='",
            {
              'diagnostics',
              symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            },
          },
          lualine_x = { 'encoding', 'fileformat' },
          lualine_y = { 'filetype', 'searchcount' },
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
      local t = {}
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
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-telescope/telescope-frecency.nvim",
      'fannheyward/telescope-coc.nvim',
      'tom-anders/telescope-vim-bookmarks.nvim'
    },
    keys = {
      { '<C-j>f', ':Telescope find_files find_command=rg,--files,--hidden,--glob,!*.git <CR>' },
      { '<C-j>z', ':Telescope frecency<CR>' },
      { '<C-j>e', ':Telescope oldfiles<CR>' },
      { '<C-j>g', ':Telescope live_grep<CR>' },
      { '<C-j>l', ':Telescope current_buffer_fuzzy_find<CR>' },
      { '<C-j>p', ':Telescope commands<CR>' },
      { '<C-j>:', ':Telescope command_history<CR>' },
      { '<C-j>m', ':Telescope vim_bookmarks all<CR>' },
      { '<C-j>i', ':Telescope coc implementations<CR>' },
      { '<C-j>h', ':Telescope coc references_used<CR>' },
      { '<C-j>s', ':Telescope coc workspace_symbols<CR>' },
      { '<C-j>c', ":lua require'telescope.builtin'.git_status{}<CR>" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-a>"] = actions.smart_add_to_qflist + actions.open_qflist,
              ["<C-o>"] = actions.smart_send_to_qflist + actions.open_qflist,
              -- Ctrl+Enterがマッピングされている
              ["<F12>"] = actions.select_vertical,
            },
            n = { ["q"] = actions.close },
          },
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            vertical = { width = 0.9 },
            prompt_position = "top",
            preview_cutoff = 1,
          },
        },
        extensions = {
          frecency = {
            show_scores = true
          },
          coc = {
            -- trueだと常にpreviewを経由する
            prefer_locations = false,
          }
        }
      }

      require("telescope").load_extension("frecency")
      require('telescope').load_extension('coc')
      require('telescope').load_extension('vim_bookmarks')
    end
  },

  -- エクスプローラー
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    keys = {
      { '<M-w>',  ':NvimTreeToggle<CR>' },
      { '<C-j>w', ':NvimTreeFindFile<CR>' }
    },
    config = function()
      require("nvim-tree").setup {
        view = {
          preserve_window_proportions = true,
        },
        renderer = {
          icons = {
            glyphs = {
              git = {
                unstaged = "",
                staged = "󰆼",
                unmerged = "",
                renamed = "󰮆",
                untracked = "",
                deleted = "",
                ignored = "",
              }
            },
          }
        },

        diagnostics = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
          icons = {
            hint = " ",
            info = " ",
            warning = " ",
            error = " ",
          },
        },

        on_attach = function(bufnr)
          local api = require "nvim-tree.api"
          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          api.config.mappings.default_on_attach(bufnr)
          -- ここからカスタマイズhotkeys
          key('n', '<Space>-', api.node.open.horizontal, opts('Open horizontal'))
          key('n', '<Space>i', api.node.open.vertical, opts('Open vertical'))
        end
      }
    end
  },

  -- TUIツール
  {
    "is0n/fm-nvim",
    keys = {
      { '<Space>g', ':Lazygit<CR>' },
      { '<C-j>r',   ':Broot<CR>' },
    },
    config = function()
      require('fm-nvim').setup {
        ui = {
          float = {
            height = 0.99,
            width = 0.99,
          }
        },

        broot_conf = "~/.config/broot/conf.nvim.toml"
      }
    end
  },

  -- Gitの行表示
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufNewFile', 'BufRead' },
    keys = {
      { '<Space>d', ':Gitsigns preview_hunk<CR>' },
      { '<C-j>D',   ':Gitsigns diffthis<CR>' },
      { '<Space>u', ':Gitsigns reset_hunk<CR>' },
      { '<Space>s', ':Gitsigns stage_hunk<CR>' },
      { '<Space>j', ':Gitsigns next_hunk<CR>' },
      { '<Space>k', ':Gitsigns prev_hunk<CR>' },
    },
    config = function()
      vim.defer_fn(function()
        require('gitsigns').setup {
          signcolumn = false,
          numhl = true,
        }
      end, is_windows and 200 or 0)
    end
  },

  -- Git blame
  {
    "FabijanZulj/blame.nvim"
  },

  -- Gitの行履歴詳細表示
  {
    'rhysd/git-messenger.vim',
    config = function()
      vim.g.git_messenger_include_diff = "current"
    end
  },

  -- VSCode like
  {
    'neoclide/coc.nvim',
    branch = "release",
    event = { 'BufNewFile', 'BufRead' },
    keys = {
      -- 定義に移動
      { '<C-]>', '<Plug>(coc-definition)' },
      -- import最適化
      { '<M-o>', ':call CocAction(\'runCommand\', \'editor.action.organizeImport\')<CR>' },
      -- 配下の定義を表示
      { '<M-s>', ':call CocActionAsync(\'doHover\')<CR>' },
      {
        '<C-P>',
        '<C-\\><C-O>:call CocActionAsync(\'showSignatureHelp\')<CR>',
        mode = "i"
      },
      -- 前後のエラーや警告に移動
      { '<M-k>', '<Plug>(coc-diagnostic-prev)' },
      { '<M-j>', '<Plug>(coc-diagnostic-next)' },
      -- Enterキーで決定
      {
        "<cr>",
        [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
        mode = "i",
        expr = true,
        replace_keycodes = false
      },
      -- 上下で候補選択
      {
        "<down>",
        [[coc#pum#visible() ? coc#pum#next(1) : "<down>"]],
        mode = "i",
        expr = true,
        replace_keycodes = false
      },
      {
        "<up>",
        [[coc#pum#visible() ? coc#pum#prev(1): "<up>"]],
        mode = "i",
        expr = true,
        replace_keycodes = false
      },
      -- TABでsnippets展開とplaceholder移動
      {
        "<tab>",
        '<Plug>(coc-snippets-expand-jump)',
        mode = "i"
      },
      -- code action
      { '<M-CR>',  '<Plug>(coc-codeaction-cursor)' },
      -- Rename
      { '<S-M-r>', '<Plug>(coc-rename)' },
      -- Auto complete
      {
        "<F5>",
        [[coc#refresh()]],
        mode = "i",
        expr = true
      },
    },
    config = function()
      local extensions = {
        "@yaegassy/coc-marksman",
        "@yaegassy/coc-volar",
        "coc-biome",
        "coc-css",
        "coc-deno",
        "coc-elixir",
        "coc-go",
        "coc-html",
        "coc-java",
        "coc-json",
        "coc-prettier",
        "coc-pyright",
        "coc-rust-analyzer",
        "coc-snippets",
        "coc-tsserver",
        "coc-yaml",
      }
      if not is_windows then
        -- Windowsは未対応らしいので...
        table.insert(extensions, { "coc-lua" })
      end
      vim.g.coc_global_extensions = extensions

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.go" },
        command = "call CocAction('runCommand', 'editor.action.organizeImport')"
      })
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
  },

  -- Swagger UI preview
  {
    "vinnymeller/swagger-preview.nvim",
    config = function()
      require("swagger-preview").setup({
        port = 8000,
        host = "localhost",
      })
    end
  },

  -- mini.nvim
  {
    'echasnovski/mini.nvim',
    version = false,
    event = { 'BufNewFile', 'BufRead' },
    config = function()
      local miniclue = require('mini.clue')
      require('mini.clue').setup({
        window = {
          delay = 500
        },
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })

      require('mini.indentscope').setup()

      require('mini.cursorword').setup()
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*',
        callback = function()
          local filetype = vim.bo.filetype
          if filetype == 'aerial' or filetype == 'NvimTree' then
            vim.api.nvim_set_hl(0, 'MiniCursorword', { fg = 'NONE', bg = 'NONE' })
          else
            vim.api.nvim_set_hl(0, 'MiniCursorword', { fg = 'lightgray', bg = 'darkcyan' })
          end
        end
      })
    end
  },

  -- 現在行にカーソルを表示し、一定以上移動したらアニメーションで追従する
  {
    'gen740/SmoothCursor.nvim',
    config = function()
      require('smoothcursor').setup({
        fancy = {
          enable = true,
          head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
          body = {
            { cursor = "●", texthl = "SmoothCursorYellow" },
            { cursor = "●", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = ".", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
          },
          tail = { cursor = nil, texthl = "SmoothCursor" },
        },
      })
    end
  },


  -- 通知とコマンドラインを強化
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require('noice').setup({
        presets = {
          command_palette = true,
        },
        messages = {
          enabled = true,
          view = "mini",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = false,
        },
      })
    end
  },

  -- TODO系のコマンドを目立たせる --
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { 'BufNewFile', 'BufRead' },
    keys = {
      { '<C-j>x', ':TodoTelescope<cr>' },
    },
    opts = {
      sign_priority = 1
    },
  },

  -- アウトラインの表示
  {
    'stevearc/aerial.nvim',
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { '<C-j>o', ':AerialOpen<CR>' },
    },
    config = function()
      require("aerial").setup({
        layout = {
          default_direction = "float",
          min_width = 50
        },
        keymaps = {
          ["<ESC>"] = "actions.close",
        },
      })
    end
  }
}

require('lazy').setup(
  merge_tables(common_plugins, is_vscode and vscode_plugins or neovim_plugins)
)

if not is_vscode then
  vim.cmd('colorscheme gruvbox-material')
end

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
-- Hippie completion
if is_windows then
  key('i', '<S-F6>', '<C-x><C-p>')
else
  key('i', '<F18>', '<C-x><C-p>') -- Ubuntu(WSL)ではS-F6がF18となるため
end
-- 行オートコンプリート
key('i', '<C-l>', '<C-x><C-l>')
-- cnext / cprevious
key('n', '<Space>n', ':cnext<CR>')
key('n', '<Space>p', ':cprevious<CR>')
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

-- ステータスバーは分割しない
set.laststatus = 3

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
