set -eu

# 変数設定
MNT="https://raw.githubusercontent.com/tadashi-aikawa/owl-playbook/master/mnt"

# configディレクトリ
mkdir .config
mkdir .config/broot

# 依存関係インストール
sudo apt-get update -y
# nvim-treesitterで使用
sudo apt-get install -y build-essential
# Pythonとtelescope-frecencyで使用
sudo apt-get install -y libsqlite3-dev
# Brootで使用
sudo apt-get install -y unzip
# Pythonで使用
sudo apt-get install -y \
  libbz2-dev \
  libncurses-dev \
  libreadline-dev \
  libssl-dev \
  libffi-dev \
  liblzma-dev \
  zlib1g-dev

# gitconfig
cat > ~/.bashrc << 'EOF'
[user]
    email = syou.maman@gmail.com
    name = tadashi-aikawa

[core]
    autoCRLF = false
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true    # use n and N to move between diff sections
    light = false      # set to true if you're in a terminal w/ a light background color (e.g. the default macOS terminal)
    side-by-side = true

[merge]
    conflictstyle = diff3

[diff]
    colorMoved = default

EOF

# .bashrc
cat > ~/.bashrc << 'EOF'
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
alias gll='git-graph -n 30 -s round'
alias gls='git-graph -n 15 -s round --format "%h %d %s%n 💿%ad 👤<%ae>%n'
alias glll="git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b'"
alias glls="git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' -10"
alias gbm='git merge --no-ff $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gs='git status --short'
alias gss='git status -v'

EOF

# asdfインストール
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc

# $1: package name, $2: version $3?: url
function asdf_install() {
  asdf plugin add $1 $3
  asdf install $1 $2
  asdf global $1 $2
}

# Starshipインストール
asdf_install starship latest
echo 'eval "$(starship init bash)"' >> ~/.bashrc
starship preset bracketed-segments > ~/.config/starship.toml

# Brootインストール
asdf_install broot latest https://github.com/cmur2/asdf-broot.git
wget ${MNT}/linux/ubuntu/broot.toml -O ~/.config/broot/conf.toml

# Neovim
asdf_install neovim 0.8.3
echo 'alias vim=nvim' >> ~/.bashrc
mkdir -p ~/.config/nvim
wget ${MNT}/common/nvim/init.lua -O ~/.config/nvim/init.lua
wget ${MNT}/common/nvim/coc-settings.json -O ~/.config/nvim/coc-settings.json
wget ${MNT}/common/nvim/lazy-lock.json -O ~/.config/nvim/lazy-lock.json

# GitUI
asdf_install gitui latest
wget ${MNT}/common/gitui/key_bindings.ron -O ~/.config/gitui/key_bindings.ron

# Node.js
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf nodejs update-nodebuild
lts=$(asdf nodejs resolve lts --latest-available)
asdf install nodejs ${lts}
asdf global nodejs ${lts}

# ripgrep
asdf_install ripgrep latest

# zoxide
asdf_install zoxide latest https://github.com/nyrst/asdf-zoxide.git
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc

# eza
asdf_install eza latest
echo 'alias tree="eza --icons -T"' >> ~/.bashrc
echo 'alias ll="eza --icons -l --git"' >> ~/.bashrc

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
echo 'alias cdz="zi"' >> ~/.bashrc
echo 'export FZF_DEFAULT_OPTS="--reverse --border --height 50%"' >> ~/.bashrc

# delta
asdf_install delta latest https://github.com/andweeb/asdf-delta.git

# git-graph
wget https://github.com/mlange-42/git-graph/releases/download/0.5.3/git-graph-0.5.3-linux-amd64.tar.gz -O /tmp/git-graph.tar.gz
sudo tar xvf /tmp/git-graph.tar.gz -C /usr/local/bin/

# Task
asdf_install task latest

# After
echo "Run Broot"
echo "Run Neovim"
echo "Run ~/.fzf/install"
