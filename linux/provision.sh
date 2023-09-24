set -eu

# 変数設定
MNT="https://raw.githubusercontent.com/tadashi-aikawa/owl-playbook/master/mnt"

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
cp $MNT/linux/ubuntu/gitconfig ~/.gitconfig

# .bashrc
cp $MNT/linux/ubuntu/bashrc/base.sh ~/.bash.sh
echo "sorce ~/.bash.sh" >> ~/.bashrc

# asdfインストール
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
cp $MNT/linux/ubuntu/bashrc/asdf.sh ~/.asdf.sh
echo "sorce ~/.asdf.sh" >> ~/.bashrc
source ~/.asdf.sh

# $1: package name, $2: version $3?: url
function asdf_install() {
  asdf plugin add $1 ${3:-""}
  asdf install $1 $2
  asdf global $1 $2
}

# Starshipインストール
asdf_install starship latest
cp $MNT/linux/ubuntu/bashrc/starship.sh ~/.starship.sh
echo "sorce ~/.starship.sh" >> ~/.bashrc
source ~/.starship.sh
starship preset bracketed-segments > ~/.config/starship.toml

# Brootインストール
asdf_install broot latest https://github.com/cmur2/asdf-broot.git
mkdir -p ~/.config/broot
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
mkdir -p ~/.config/gitui
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
