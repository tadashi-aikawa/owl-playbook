# shellcheck disable=SC1090,SC2012

export PATH="$PATH:/usr/local/go/bin:~/go/bin:~/.pyenv/bin:~/.local/share/umake/ide/idea/bin"
export GOPATH="$HOME/go"

# 日本語入力
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx

# クリップボード連携 (For WSL2)
LOCAL_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
export DISPLAY=$LOCAL_IP:0

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

# alias
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias cdr='cd $(fd -H -t d | fzf)'
alias cdz='cd $(z -l | cut -c 12- | fzf)'
alias cdg='cd $(gowl list | fzf)'

alias ga='git add'
alias gaa='git add --all'
alias gb='git checkout $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gbc='git checkout -b'
alias gco='git commit -m'
alias gbr='git branch -rl | grep -vE "HEAD|master" | tr -d " " | sed -r "s@origin/@@g" | fzf | xargs -i git checkout -b {} origin/{}'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --all'
alias gl='git log'
alias gll='git log -10 --oneline --all --graph --decorate'
alias gls='git log -3'
alias glll="git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b'"
alias glls="git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' -10"
alias gbm='git merge --no-ff $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gs='git status --short'
alias gss='git status -v'

alias ll='exa -l --icons --git'
alias tree='exa -lT --icons --git'

alias pj='pipenv run python jumeaux/executor.py'

alias vimn='vim -u NONE -N'
alias vimr='vim $(fd -H | fzf)'
alias vimz='vim $(grep "^>" ~/.viminfo | cut -c 3- | sed "s@~@$HOME@" | fzf)'


# pyenv
eval "$(pyenv init -)"


