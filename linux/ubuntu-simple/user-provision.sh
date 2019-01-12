#!/bin/bash

# ベキトウセイはない

# z
echo ". /usr/local/bin/z" >> ~/.bashrc

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --update-rc

cat >> ~/.bashrc << 'EOF'
# fzfの設定
export FZF_DEFAULT_OPTS="--reverse --border --height 50%"
# fzfのCtrl+T設定 ファイルの中身を表示して200行をプレビュー
export FZF_CTRL_T_OPTS="--preview 'bat --color \"always\" {}' --height 90%"
# fzfのALt+C設定 ツリー表示して200行をプレビュー
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200' --height 90%"
EOF

# pureline
git clone https://github.com/tadashi-aikawa/pureline-inspired.git ~/pureline-inspired
chown -R vagrant:vagrant ~/pureline-inspired
echo "source ~/pureline-inspired/pureline ~/pureline-inspired/.pureline.conf" >> ~/.bashrc

# alias
cat >> ~/.bashrc << 'EOF'
alias cdr='cd $(fd -H -t d | fzf)'
alias cdz='cd $(z -l | cut -c 12- | fzf)'
alias cdg='cd $(gowl list | fzf)'

alias ga='git add'
alias gaa='git add --all'
alias gc='git checkout $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gcm='git commit -m'
alias gcr='git branch -rl | grep -vE "HEAD|master" | tr -d " " | sed -r "s@origin/@@g" | fzf | xargs -i git checkout -b {} origin/{}'
alias gcv='git commit -v'
alias gd='git diff'
alias gf='git fetch'
alias gfx='for d in $(ls | fzf --multi); do cd $d && echo [$d] && git fetch --all --prune -q && git rev-list --count --left-right @{upstream}...HEAD | awk '\''{print " ↓"$1" ↑"$2}'\'' && cd ..; done'
alias gl='git log'
alias gll='git log --oneline --all --graph --decorate'
alias gls='git log -3'
alias glll="git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b'"

alias gs='git status --short'
alias gsv='git status -v'
EOF

# ssh
chmod 600 .ssh/id_rsa*

# dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein

# sync
ln -snf /mnt/.vim        .vim
ln -snf /mnt/.vimrc      .vimrc
ln -snf /mnt/.tmux.conf  .tmux.conf

cat << 'EOF'
Please manually....

aws configure

vim
call dein#install()
EOF
