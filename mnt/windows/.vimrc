" ---------------------------------------------------
"  Dein scripts
" ---------------------------------------------------
" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#load_toml('~/.vim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/dein_lazy.toml', {'lazy': 1})

  " Required
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on


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
" " TABなどを可視化
set list
set listchars=tab:»˙,trail:˙,eol:↲,extends:»,precedes:«,nbsp:%
" タブを常に表示する
set showtabline=2
" タブの色
" :hi TabLine     ctermfg=White ctermbg=240
" :hi TabLineFill ctermfg=Black ctermbg=Black
" :hi TabLineSel  ctermfg=White ctermbg=196

" Python
augroup python
  autocmd!
  autocmd FileType python setl autoindent
  autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
augroup END


" -------------------------- Status bar ---------------------------
let g:last_mode = ""

function! Mode()
  let l:mode = mode()

  if l:mode !=# g:last_mode
    let g:last_mode = l:mode

    hi User2 guifg=#005f00 guibg=#dfff00 gui=BOLD ctermfg=22 ctermbg=190 cterm=BOLD
    hi User3 guifg=#FFFFFF guibg=#414243 ctermfg=255 ctermbg=241
    hi User4 guifg=#414234 guibg=#2B2B2B ctermfg=241 ctermbg=234
    hi User5 guifg=#4e4e4e guibg=#FFFFFF gui=bold ctermfg=239 ctermbg=255 cterm=bold
    hi User6 guifg=#FFFFFF guibg=#8a8a8a ctermfg=255 ctermbg=245
    hi User7 guifg=#ffff00 guibg=#8a8a8a gui=bold ctermfg=226 ctermbg=245 cterm=bold
    hi User8 guifg=#8a8a8a guibg=#414243 ctermfg=245 ctermbg=241

    if l:mode ==# 'n'
      hi User3 guifg=#dfff00 ctermfg=190
    elseif l:mode ==# "i"
      hi User2 guifg=#005fff guibg=#FFFFFF ctermfg=27 ctermbg=255
      hi User3 guifg=#FFFFFF ctermfg=255
    elseif l:mode ==# "R"
      hi User2 guifg=#FFFFFF guibg=#df0000 ctermfg=255 ctermbg=160
      hi User3 guifg=#df0000 ctermfg=160
    elseif l:mode ==? "v" || l:mode ==# ""
      hi User2 guifg=#4e4e4e guibg=#ffaf00 ctermfg=239 ctermbg=214
      hi User3 guifg=#ffaf00 ctermfg=214
    endif
  endif 

  if l:mode ==# "n"
    return "  NORMAL "
  elseif l:mode ==# "i"
    return "  INSERT "
  elseif l:mode ==# "R"
    return "  REPLACE "
  elseif l:mode ==# "v"
    return "  VISUAL "
  elseif l:mode ==# "V"
    return "  V·LINE "
  elseif l:mode ==# ""
    return "  V·BLOCK "
  else
    return l:mode
  endif
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'OK' : printf(
    \   '☠ %d ⚠ %d ⬥ ok',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%2*%{Mode()}%3*⮀%1*
set statusline+=%#StatusLine#
set statusline+=%{strlen(fugitive#statusline())>0?'\ ⭠\ ':''}
set statusline+=%{matchstr(fugitive#statusline(),'(\\zs.*\\ze)')}
set statusline+=%{strlen(fugitive#statusline())>0?'\ \ ⮁\ ':'\ '}
set statusline+=%f\ %{&ro?'⭤':''}%{&mod?'+':''}%<
set statusline+=%3*\ 
set statusline+=%{LinterStatus()}
"
set statusline+=\ %4*⮀
set statusline+=%#warningmsg#
set statusline+=%=
set statusline+=%4*⮂
set statusline+=%#StatusLine#
set statusline+=\ %{strlen(&fileformat)>0?&fileformat.'\ ⮃\ ':''}
set statusline+=%{strlen(&fileencoding)>0?&fileencoding.'\ ⮃\ ':''}
set statusline+=%{strlen(&filetype)>0?&filetype:''}
set statusline+=\ %8*⮂
set statusline+=%7*\ %p%%\ 
set statusline+=%6*⮂%5*⭡\ \ %l:%c\ 


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

"---- Alt -------
" [quick-run] Golangの実行
autocmd FileType go nnoremap <M-r> :QuickRun<CR>
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

" ---------------- z -------------------
function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter()
  \   ],
  \ }), get(a:, 1, {}))
endfunction
" [incsearch-fuzzy] /
noremap <silent><expr> z/ incsearch#go(<SID>config_fuzzyall())
" [incsearch-fuzzy] ?
noremap <silent><expr> z? incsearch#go(<SID>config_fuzzyall({'command': '?'}))


" ------------- <Space> ----------------

" [deopelete] 有効
nnoremap <Space>a :call deoplete#enable()<CR>
" [lsp] 定義
nmap <silent> <Space>d :LspDefinition<CR>
" [ctrlp] MRU files
nnoremap <silent> <Space>e :CtrlPMRUFiles<CR>
" ウィンドウ左移動
nnoremap <silent> <Space>h <C-w>h
" 呼び出し履歴
autocmd FileType go nnoremap <silent> <Space>H :GoReferrers<CR>
"次のエラー
"Golang
autocmd FileType go nnoremap <Space>j :cnext<CR>
"前のエラー
"Golang
autocmd FileType go nnoremap <Space>k :cprevious<CR>
"ウィンドウ右移動
nnoremap <silent> <Space>l <C-w>l
" [ctrlp] Line
nnoremap <silent> <Space>L :CtrlPLine<CR>
"ウィンドウ切り替え
nnoremap <silent> <Space><Space> <C-w>w
" [NERDTree] ON/OFF切り替え
nnoremap <silent> <Space>n :<C-u>:NERDTreeTabsToggle<CR>
" [unite-outline] アウトライン
nnoremap <silent> <Space>o :Unite -vertical -winwidth=40 -no-quit outline<CR>
" [vim-go] Goの場合はGoDecls
autocmd FileType go nnoremap <Space>o :GoDecls<CR>
" [lsp] Hover
nmap <silent> <Space>p :LspHover<CR>
" バッファ切り替え
nnoremap <Space>r :b#<CR>

"
" URL Encode
vnoremap <Space>sen :!python -c 'import sys,urllib;print urllib.quote(sys.stdin.read().strip())'<cr>
" URL Decode
vnoremap <Space>sde :!python -c 'import sys,urllib;print urllib.unquote(sys.stdin.read().strip())'<cr>
" Dropbox URL transform
nnoremap <silent> <Space>sdr v:!python -c 'import sys; print sys.stdin.read().strip().replace("https://www.dropbox.com/s", "https://dl.dropboxusercontent.com/s").replace("?dl=0", "")'<cr>
" Markdown h1 header
nnoremap <silent> <Space>sh= v:!python3 -c 'import sys; from unicodedata import east_asian_width; w=sys.stdin.read().strip(); l=sum(map(lambda x: 2 if east_asian_width(x) in "FWA" else 1, w)); print(w+"\n"+"="*l)'<cr>
" Markdown h2 header
nnoremap <silent> <Space>sh- v:!python3 -c 'import sys; from unicodedata import east_asian_width; w=sys.stdin.read().strip(); l=sum(map(lambda x: 2 if east_asian_width(x) in "FWA" else 1, w)); print(w+"\n"+"-"*l)'<cr>
" URL query parsing
vnoremap <Space>spq :!python -c 'import sys,urllib;print urllib.parse_qs(sys.stdin.read().strip())'<cr>

" [Encoding] => cp932
nnoremap <silent> <Space>S :e ++enc=cp932<cr>
" [ctrlp] Buffer
nnoremap <silent> <Space>t :CtrlPBuffer<CR>
" [NERDTree] Treeに移動し、カレントファイルをフォーカス
nnoremap <silent> <Space>w :<C-u>:NERDTreeTabsFind<CR>
"
" [Markdown] テーブルをフォーマッティングする
nnoremap <silent> <Space>@ :<C-u>TableFormat<CR>
" [vim-over]
nnoremap <silent> <Space>// :OverCommandLine<CR>%s/



" ---------------------------------------------------
" 新規作成時のテンプレート
" ---------------------------------------------------
" autocmd BufNewFile test_*.py 0r ~/.vim-snippets/newtmpl/pytest.py
autocmd BufNewFile *.py 0r ~/.vim-snippets/newtmpl/python.py
autocmd BufNewFile *.sh 0r ~/.vim-snippets/newtmpl/bash.sh

