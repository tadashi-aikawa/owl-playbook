local set = vim.opt
local key = vim.keymap.set

-----------------------------------------------------
--  全体
-----------------------------------------------------
-- 文字コード自動判別
set.encoding = "utf-8"
-- 改行コード自動判別
set.fileformats="unix,dos,mac"

--------------------------------------------------------
--  vim-plug
--------------------------------------------------------
local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- VSCode like
Plug('neoclide/coc.nvim', {branch = 'release'})
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

-- yank範囲のハイライト
Plug 'machakann/vim-highlightedyank'
vim.g.highlightedyank_highlight_duration = 300 -- ★global

-- 囲まれているものの操作
Plug 'machakann/vim-sandwich'

-- ブラックホールレジスト+putの省略
Plug 'vim-scripts/ReplaceWithRegister'
key('n', '_', '<Plug>ReplaceWithRegisterOperator')

-- 全体が範囲のtext-object
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'

-- コメント化
Plug 'tpope/vim-commentary'

-- CamelCaseMotion
Plug 'bkad/CamelCaseMotion'
vim.g.camelcasemotion_key = ']'

-- 画面内瞬間移動
Plug 'easymotion/vim-easymotion'
key('n', 's', '<Plug>(easymotion-overwin-f2)')
vim.g.EasyMotion_do_mapping = 0
vim.g.EasyMotion_smartcase = 1

-- Theme
Plug 'morhetz/gruvbox'

-- マルチカーソル
Plug 'mg979/vim-visual-multi'
vim.api.nvim_command('let g:VM_maps = {}')
vim.api.nvim_command("let g:VM_maps['Find Under'] = '<C-k>'")
vim.api.nvim_command("let g:VM_maps['Find Subword Under'] = '<C-k>'")

-- ステータスLine
Plug 'itchyny/lightline.vim'
vim.g.lightline = { colorscheme = 'jellybeans' }

-- " Fern
Plug 'lambdalisue/fern.vim'
key('n', '<C-j>w', ':Fern %:h -drawer -width=50<cr>', { noremap = true })
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
vim.cmd([[
augroup my-glyph-palette
autocmd! *
autocmd FileType fern call glyph_palette#apply()
autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
]])
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
vim.g['fern#renderer'] = "nerdfont"
Plug 'lambdalisue/fern-git-status.vim'

-- mark
Plug 'kshenoy/vim-signature'

-- telescope
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.1' })

vim.call('plug#end')

vim.cmd("runtime macros/sandwich/keymap/surround.vim")
vim.cmd("filetype plugin indent on")

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

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-j>f', builtin.find_files, {})
vim.keymap.set('n', '<C-j>e', builtin.oldfiles, {})

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
-- " バッファ切り替え
key('n', '<M-Left>', ':bprev<CR>')
key('n', '<M-Right>', ':bnext<CR>')
key('n', '<Space>r', ':b#<CR>')

