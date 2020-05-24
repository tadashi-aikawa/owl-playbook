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

" タブを常に表示する
set showtabline=2
" タブの色
" :hi TabLine     ctermfg=White ctermbg=240
" :hi TabLineFill ctermfg=Black ctermbg=Black
" :hi TabLineSel  ctermfg=White ctermbg=196

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
" [gitgutter] 0.1秒おきに表示を更新する
set updatetime=100
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
" set clipboard=unnamedplus
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
"  Key bindings
" ---------------------------------------------------

" [vim-anzu] 検索強化
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
" [easy-motion]
nmap s <Plug>(easymotion-overwin-f2)
" [operator-replace] オペレータリプレイス
nmap _ <Plug>(operator-replace)
" [vim-anzu] 検索強化
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

" snippet 次へ
let g:UltiSnipsJumpForwardTrigger="<tab>"
" snippet 前へ
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


"---- Ctrl -------

" <C-Space>でオートコンプリート
imap <Nul> <C-x><C-o>
" [multi-cursor] 作成
let g:multi_cursor_start_key='<C-k>'
" [multi-cursor] 拡張
let g:multi_cursor_next_key='<C-k>'
" 行オートコンプリート
imap <C-l> <C-x><C-l>

"---- Ctrl + j からの... -------
"  バッファから開く
nnoremap <C-j>b :CtrlPBuffer<CR>
"  履歴から開く
nnoremap <C-j>e :CtrlPMRU<CR>
" nnoremap <C-j>e  :<C-u>/ oldfiles<Home>browse filter /
" [fzf] 全文検索
" nnoremap <C-j>g :Rg<Space>
" [NERDTree] ON/OFF切り替え
nnoremap <C-j>n :<C-u>:NERDTreeTabsToggle<CR>
" [fzf] タグへ移動
" nnoremap <C-j>o :Tags<CR>
" [fzf] ファイルのfuzzy検索
" nnoremap <C-j>f :call FzfOmniFiles()<CR>
" [fzf] Gitステータス
" nnoremap <C-j>s :GFiles?<CR>
" [NERDTree] Treeに移動し、カレントファイルをフォーカス
nnoremap <C-j>w :<C-u>:NERDTreeTabsFind<CR>

" ---------------- g -------------------

" [vim-gitgutter] 次のハンクへ移動
nmap gij <Plug>GitGutterNextHunk
" [vim-gitgutter] 前のハンクへ移動
nmap gik <Plug>GitGutterPrevHunk
" [vim-gitgutter] ハンクを元に戻す
nmap giu <Plug>GitGutterUndoHunk
" [vim-gitgutter] ハンクをプレビューする
nmap gip <Plug>GitGutterPreviewHunk

" 全て閉じる
nnoremap <silent> go :qa<CR>

" ------------- <Space> ----------------

" ウィンドウ切り替え
nnoremap <silent> <Space><Space> <C-w>w
" [Markdown] テーブルをフォーマッティングする
nnoremap <silent> <Space>@ :<C-u>TableFormat<CR>
" [vim-over]
nnoremap <silent> <Space>// :OverCommandLine<CR>%s/

" ウィンドウ左移動
nnoremap <silent> <Space>h <C-w>h
"ウィンドウ右移動
nnoremap <silent> <Space>l <C-w>l
" バッファ切り替え
nnoremap <Space>r :b#<CR>
" [Encoding] => cp932
nnoremap <silent> <Space>S :e ++enc=cp932<cr>



" ---------------------------------------------------
" 新規作成時のテンプレート
" ---------------------------------------------------
autocmd BufNewFile *.sh 0r ~/.vim-snippets/newtmpl/bash.sh

set nomodeline

