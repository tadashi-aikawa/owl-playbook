alias su='iconv -f Shift-Jis -t utf-8'
# for symlink in windows
export MSYS=winsymlinks:nativestrict
export LANG=ja_JP.UTF-8

# https://qiita.com/cointoss1973/items/a0da81df10f8cc04c83e
alias python='winpty python.exe'
alias gowl='winpty -Xallow-non-tty gowl'
alias fzf='winpty -Xallow-non-tty fzf'

# alias
alias acmd='powershell -command "Start-Process -Verb runas cmd"'

alias cdr='cd $(fd -H -t d | fzf)'
alias cdz='cd $(z -l | cut -c 12- | fzf)'
alias cdg='cd $(gowl list | fzf)'

alias ga='git add'
alias gaa='git add --all'
# alias gc='git checkout $(git branch -l | grep -vE "^\*" | tr -d " " | fzf --preview "git log --oneline --all --graph --decorate $(git rev-parse --abbrev-ref HEAD)..{}")'
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
# alias gm='git merge --no-ff $(git branch -l | grep -vE "^\*" | tr -d " " | fzf --preview "git log --oneline --all --graph --decorate $(git rev-parse --abbrev-ref HEAD)..{}")'
alias gbm='git merge --no-ff $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gs='git status --short'
alias gss='git status -v'

alias ll='ls -l'


function to_win_path() {
  path=${*}
  echo "$(readlink -f ${path} | sed -e 's@/@\\@g' -e 's@\\c\\@c:\\@g' | tr '\n' ' ')"
}

function tree() {
  dst="$(to_win_path ${1:-$(pwd)})"
  cmd //c "chcp 437 & tree ${dst}" //a //f
}

function te() {
  dst="$(to_win_path ${1:-$(pwd)})"
  /c/tablacus/TE64 ${dst}
}


alias gift="/c/Work/git/gift/.venv/Scripts/python.exe /c/Work/git/gift/gift/main.py"
