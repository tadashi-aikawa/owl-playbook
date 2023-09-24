set -eu

COMMON_MNT="mnt/common"
UBUNTU_MNT="mnt/linux/ubuntu"

# $1: package name, $2: version $3?: url
function asdf_install() {
  asdf plugin add $1 ${3:-""}
  asdf install $1 $2
  asdf global $1 $2
}

ensure_bashrc() {
  local content="$1"

  if ! grep -qxF -- "$content" ~/.bashrc; then
      echo "$content" >> ~/.bashrc
      echo "'${content}' was added to .bashrc."
  else
      echo "'${content}' is already present in .bashrc."
  fi
}


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
cp $UBUNTU_MNT/gitconfig ~/.gitconfig

# .bashrc
cp $UBUNTU_MNT/bashrc/base.sh ~/.bash.sh
ensure_bashrc "source ~/.bash.sh"

# asdfインストール
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
cp $UBUNTU_MNT/bashrc/asdf.sh ~/.asdf.sh
ensure_bashrc "source ~/.asdf.sh"
source ~/.asdf.sh

# Starshipインストール
asdf_install starship latest
cp $UBUNTU_MNT/bashrc/starship.sh ~/.starship.sh
ensure_bashrc "source ~/.starship.sh"
mkdir -p ~/.config
starship preset bracketed-segments > ~/.config/starship.toml

# Brootインストール
asdf_install broot latest https://github.com/cmur2/asdf-broot.git
mkdir -p ~/.config/broot
cp $UBUNTU_MNT/broot.toml ~/.config/broot/conf.toml

# Neovim
asdf_install neovim 0.8.3
ensure_bashrc 'alias vim=nvim'
mkdir -p ~/.config/nvim
cp ${COMMON_MNT}/nvim/init.lua ~/.config/nvim/init.lua
cp ${COMMON_MNT}/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
cp ${COMMON_MNT}/nvim/lazy-lock.json ~/.config/nvim/lazy-lock.json

# GitUI
asdf_install gitui latest
mkdir -p ~/.config/gitui
cp ${COMMON_MNT}/gitui/key_bindings.ron ~/.config/gitui/key_bindings.ron

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
cp $UBUNTU_MNT/bashrc/zoxide.sh ~/.zoxide.sh
ensure_bashrc "source ~/.zoxide.sh"

# eza
asdf_install eza latest
cp $UBUNTU_MNT/bashrc/eza.sh ~/.eza.sh
ensure_bashrc "source ~/.eza.sh"

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cp $UBUNTU_MNT/bashrc/fzf.sh ~/.fzf.sh
ensure_bashrc "source ~/.fzf.sh"

# delta
asdf_install delta latest https://github.com/andweeb/asdf-delta.git

# git-graph
wget https://github.com/mlange-42/git-graph/releases/download/0.5.3/git-graph-0.5.3-linux-amd64.tar.gz -O /tmp/git-graph.tar.gz
sudo tar xvf /tmp/git-graph.tar.gz -C /usr/local/bin/

# Task
asdf_install task latest

# After
echo "Run broot"
echo "Run nvim"
echo "Run . ~/.fzf/install"
