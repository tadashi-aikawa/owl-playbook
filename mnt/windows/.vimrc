" ---------------------------------------------------
"  全体
" ---------------------------------------------------
" 文字コード自動判別
:set encoding=utf-8
:set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
" 改行コード自動判別
:set fileformats=unix,dos,mac
" 音を鳴らさない
:set belloff=all

" ---------------------------------------------------
"  パフォーマンス
" ---------------------------------------------------
" 無駄な描画をしない
set lazyredraw
" 再描画の速度が速くなるらしいけど最近の端末では無意味との噂も..
set ttyfast

" ---------------------------------------------------
"  見た目
" ---------------------------------------------------
" Color scheme
syntax on
" set termguicolors
set background=dark

" 行番号の表示
set number
" 検索語をハイライト
set hlsearch
" ステータスラインを常に表示
set laststatus=2
" 左下のインサートモードなどの文字を非表示にする
set noshowmode
" 折りたたみを無効
set nofoldenable
" Insertモードのときカーソルの形状を変更
let &t_ti.="\e[2 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[2 q"
let &t_te.="\e[0 q"

" ---------------------------------------------------
"  操作
" ---------------------------------------------------

" vimとの互換性を外す
set nocompatible
" バッファを未保存でも閉じる
set hidden
" バックスペースの有効化
set backspace=indent,eol,start
" コマンドのタイムラグをなくす
set ttimeoutlen=1
" タブを基本2文字に
set smarttab " (行頭の余白内: shiftwidth, 行頭以外: tabstop)
set tabstop=2
set shiftwidth=2
" タブの代わりにスペースを挿入する
set expandtab
" 1行前のインデントを考慮してインデントする
set autoindent
" スマートなインデント (Cとかでなければ必要ない??)
set smartindent
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行っても最初に戻らない
set nowrapscan
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索時に大文字を含んでいたら大/小を区別
set smartcase
" Clipboard magic?
set clipboard+=unnamed
" スクロールした時 常に下に表示するバッファ行の数
set scrolloff=5
" swapfileなし
set noswapfile
set nobackup
" Grepの結果をQuickFixに
autocmd QuickFixCmdPost *grep* cwindow

" 最後に開いていた行を開く
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

" 貼り付けを即座に反映させる
if 1
    exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
endif


" ---------------------------------------------------
"  キーバインド
" ---------------------------------------------------
" 行オートコンプリート
imap <C-l> <C-x><C-l>

" ------------- <Space> ----------------

" ウィンドウ切り替え
nnoremap <silent> <Space><Space> <C-w>w
" バッファ切り替え
nnoremap <Space>r :b#<CR>
" [Encoding] => cp932
nnoremap <silent> <Space>S :e ++enc=cp932<cr>


" ---------------------------------------------------
"  Security
" ---------------------------------------------------
set nomodeline

