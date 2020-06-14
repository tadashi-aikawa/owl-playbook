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

" xterm-Color256用. screen系の場合は外す必要あり
"set termguicolors
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
" " TABなどを可視化
set list
set listchars=tab:»˙,trail:˙,eol:↲,extends:»,precedes:«,nbsp:%
" タブを常に表示する
set showtabline=2

" Python
augroup python
  autocmd!
  autocmd FileType python setl autoindent
  autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
augroup END


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
set clipboard=unnamedplus
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

" MetaキーにAltを割り当てる
let c = 'a'
while c <= 'z'
    execute "set <M-" . c . ">=\e" . c
    execute "imap \e" . c . " <M-" . c . ">"
    execute "set <M-S-" . c . ">=\e" . toupper(c)
    execute "imap \e" . toupper(c) . " <M-" . c . ">"
    let c = nr2char(1+char2nr(c))
endw

" [vim-anzu] 検索強化
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
" [Easy Motion] 2文字で絞り込む
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
" [fzf] バッファから開く
nnoremap <C-j>b :Buffers<CR>
" [fzf] 履歴から開く
nnoremap <C-j>e :History<CR>
" [fzf] 全文検索
nnoremap <C-j>g :Rg<Space>
" [NERDTree] ON/OFF切り替え
nnoremap <C-j>n :<C-u>:NERDTreeTabsToggle<CR>
" [fzf] タグへ移動
nnoremap <C-j>o :Tags<CR>
" [fzf] ファイルのfuzzy検索
nnoremap <C-j>f :call FzfOmniFiles()<CR>
" [fzf] Gitステータス
nnoremap <C-j>s :GFiles?<CR>
" [NERDTree] Treeに移動し、カレントファイルをフォーカス
nnoremap <C-j>w :<C-u>:NERDTreeTabsFind<CR>

"---- Alt -------
" [quick-run] Golangの実行
autocmd FileType go nnoremap <M-r> :QuickRun<CR>
" [quick-run] Pythonの実行
autocmd FileType python nnoremap <M-r> :QuickRun<CR>
" [quick-run] Nodeの実行
autocmd FileType javascript nnoremap <M-r> :QuickRun<CR>
" [vim-go] 定義異動した後に元の場所へ戻る
autocmd FileType go nnoremap <A-Left> :GoDefPop <CR>
" ---------------- g -------------------

" [ALE] 次のポイントへ移動
nmap <silent> gej <Plug>(ale_next_wrap)
" [ALE] 前のポイントへ移動
nmap <silent> gek <Plug>(ale_previous_wrap)

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

" jedi
let g:jedi#documentation_command = "K"
let g:jedi#completions_command = "<C-Space>"

" ------------- <Space> ----------------

" ウィンドウ切り替え
nnoremap <silent> <Space><Space> <C-w>w
" [Markdown] テーブルをフォーマッティングする
nnoremap <silent> <Space>@ :<C-u>TableFormat<CR>
" [vim-over]
nnoremap <silent> <Space>// :OverCommandLine<CR>%s/

" [deopelete] 有効
nnoremap <Space>a :call deoplete#enable()<CR>
" [jedi] 定義へ移動
let g:jedi#goto_command = "<Space>d"
" ウィンドウ左移動
nnoremap <silent> <Space>h <C-w>h
" [vim-go] 呼び出し履歴
autocmd FileType go nnoremap <silent> <Space>H :GoReferrers<CR>
" [jedi] Usage
let g:jedi#usages_command = "<Space>H"
"次のエラー
"Golang
autocmd FileType go nnoremap <Space>j :cnext<CR>
"前のエラー
"Golang
autocmd FileType go nnoremap <Space>k :cprevious<CR>
"ウィンドウ右移動
nnoremap <silent> <Space>l <C-w>l
" バッファ切り替え
nnoremap <Space>r :b#<CR>
" [Encoding] => cp932
nnoremap <silent> <Space>S :e ++enc=cp932<cr>


nnoremap <silent> <space>j VG!jq .<CR>

"
" Markdown h1 header
nnoremap <silent> <space>h= v:!python3 -c 'import sys; from unicodedata import east_asian_width; w=sys.stdin.read().strip(); l=sum(map(lambda x: 2 if east_asian_width(x) in "FWA" else 1, w)); print(w+"\n"+"="*l)'<cr>
" Markdown h2 header
nnoremap <silent> <space>h- v:!python3 -c 'import sys; from unicodedata import east_asian_width; w=sys.stdin.read().strip(); l=sum(map(lambda x: 2 if east_asian_width(x) in "FWA" else 1, w)); print(w+"\n"+"-"*l)'<cr>


" ---------------------------------------------------
" 新規作成時のテンプレート
" ---------------------------------------------------
" autocmd BufNewFile test_*.py 0r ~/.vim-snippets/newtmpl/pytest.py
autocmd BufNewFile *.py 0r ~/.vim-snippets/newtmpl/python.py
autocmd BufNewFile *.sh 0r ~/.vim-snippets/newtmpl/bash.sh

set nomodeline
