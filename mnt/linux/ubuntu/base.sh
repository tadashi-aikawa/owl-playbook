export PATH=${PATH}:~/bin

alias i="cd"
alias s="bat"
alias e="/mnt/c/Windows/explorer.exe"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias gf="git fetch --all"
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
gbdl() {
  git fetch -p && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D
}

alias gls='git-graph -n 30 -s round'
alias gll='git-graph -n 5 -s round --format "%h %d %s%n 💿%ad 👤<%ae>%n%n"'
alias glll='git-graph -s round --format "%h %d %s%n 💿%ad 👤<%ae>%n%n"'
alias glls="git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' -10"
alias gbm='git merge --no-ff $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gs='git status --short'
alias gss='git status -v'

alias gpf="git push --force-with-lease --force-if-includes origin HEAD"

alias show='bat --pager never'

alias cdg='cd $(gowl list | fzf)'

alias lg='lazygit'
alias ld='lazydocker'
