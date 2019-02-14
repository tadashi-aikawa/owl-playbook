# shellcheck disable=SC1090,SC2012

export PATH="$PATH:/usr/local/go/bin:~/go/bin"
export GOPATH="~/go"

# クリップボード連携
export DISPLAY=:0

# Ctrl+Sの画面ロックを無効
stty stop undef

# z
. /usr/bin/z

# [fzf] 設定
export FZF_DEFAULT_OPTS="--reverse --border --height 50%"
# デフォルトコマンドfd
export FZF_DEFAULT_COMMAND='fd -HL --exclude ".git" .'
# fzfのCtrl+T設定 ファイルの中身を表示して200行をプレビュー
# export FZF_CTRL_T_OPTS="--preview 'bat --color \"always\" {}' --height 90%"
export FZF_CTRL_T_OPTS="--height 90%"
# fzfのALt+C設定 ツリー表示して200行をプレビュー
# export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200' --height 90%"
export FZF_ALT_C_OPTS="--height 90%"

# [fzf] オートコンプリートのデフォルトコマンド
_fzf_compgen_path() {
  fd -HL --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
  fd --type d -HL --exclude ".git" . "$1"
}


source ~/pureline-inspired/pureline ~/pureline-inspired/.pureline.conf

# alias
alias cdr='cd $(fd -H -t d | fzf)'
alias cdz='cd $(z -l | cut -c 12- | fzf)'
alias cdg='cd $(gowl list | fzf)'

alias ga='git add'
alias gaa='git add --all'
# alias gc='git checkout $(git branch -l | grep -vE "^\*" | tr -d " " | fzf --preview "git log --oneline --all --graph --decorate $(git rev-parse --abbrev-ref HEAD)..{}")'
alias gc='git checkout $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gcr='git branch -rl | grep -vE "HEAD|master" | tr -d " " | sed -r "s@origin/@@g" | fzf | xargs -i git checkout -b {} origin/{}'
alias gcv='git commit -v'
alias gd='git diff'
alias gf='git fetch --all'
alias gl='git log'
alias gll='git log --oneline --all --graph --decorate'
alias gls='git log -3'
alias glll="git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b'"
alias glls="git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' -10"
# alias gm='git merge --no-ff $(git branch -l | grep -vE "^\*" | tr -d " " | fzf --preview "git log --oneline --all --graph --decorate $(git rev-parse --abbrev-ref HEAD)..{}")'
alias gm='git merge --no-ff $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gs='git status --short'
alias gsv='git status -v'

alias ll='exa -l'

alias pj='pipenv run python jumeaux/executor.py'

# function
function gfx() {
  for d in $(ls | fzf --multi); do
    cd "$d" || return
    echo [$d]
    git fetch --all --prune -q
    git rev-list --count --left-right '@{upstream}...HEAD' | awk '{print " ↓"$1" ↑"$2}'
    cd ..
  done
}
