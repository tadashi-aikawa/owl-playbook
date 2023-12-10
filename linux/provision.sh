set -eu

CURRENT_DIR_PATH=$(readlink -f "$(pwd)")

MNT="${CURRENT_DIR_PATH}/mnt"
COMMON_MNT="${MNT}/common"
LINUX_MNT="${MNT}/linux"
UBUNTU_MNT="${LINUX_MNT}/ubuntu"

# $1: package name, $2: version $3?: url
function asdf_install() {
  asdf plugin add $1 ${3:-""}
  asdf install $1 $2
  asdf global $1 $2
}

# no cat && { catのインストール処理 }
function no() {
  echo "🔍 $1 コマンドの存在確認"
  ! command -v $1 > /dev/null
}

function ensure_bashrc() {
  local content="$1"

  if ! grep -qxF -- "$content" ~/.bashrc; then
      echo "$content" >> ~/.bashrc
      echo "👍 '${content}' was added to .bashrc."
  else
      echo "👌 '${content}' is already present in .bashrc."
  fi
}

function ensure_zshrc() {
  local content="$1"

  if ! grep -qxF -- "$content" ~/.zshrc; then
      echo "$content" >> ~/.zshrc
      echo "👍 '${content}' was added to .zshrc."
  else
      echo "👌 '${content}' is already present in .zshrc."
  fi
}

# WSL
sudo ln -snf $LINUX_MNT/wsl.conf /etc/wsl.conf

# 依存関係インストール
sudo apt-get update -y
# ntp
sudo apt-get install ntp
sudo systemctl enable ntp
sudo systemctl start ntp
# nvim-treesitterで使用
sudo apt-get install -y build-essential xsel
# Pythonとtelescope-frecencyで使用
sudo apt-get install -y libsqlite3-dev
# Rustで使用
sudo apt-get install -y pkg-config
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
# PlantUMLで使用
sudo apt-get install -y graphviz

# Zsh
sudo apt-get install -y zsh zsh-autosuggestions
ensure_zshrc "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# gitconfig
ln -snf $UBUNTU_MNT/gitconfig ~/.gitconfig

# .inputrc
ln -snf $UBUNTU_MNT/inputrc ~/.inputrc

# .bashrc
ln -snf $UBUNTU_MNT/base.sh ~/.base.sh
ensure_bashrc "source ~/.base.sh"
# .zshrc
ln -snf $UBUNTU_MNT/zshrc/base.sh ~/.basez.sh
ensure_zshrc "source ~/.base.sh"
ensure_zshrc "source ~/.basez.sh"

# asdfインストール
no asdf && {
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1;
  source $UBUNTU_MNT/bashrc/asdf.sh;
}
ln -snf $UBUNTU_MNT/bashrc/asdf.sh ~/.asdf.sh;
ensure_bashrc "source ~/.asdf.sh";
ln -snf $UBUNTU_MNT/zshrc/asdf.sh ~/.asdfz.sh;
ensure_zshrc "source ~/.asdfz.sh";

# Starshipインストール
no starship && asdf_install starship latest
ln -snf $UBUNTU_MNT/bashrc/starship.sh ~/.starship.sh;
ensure_bashrc "source ~/.starship.sh";
ln -snf $UBUNTU_MNT/zshrc/starship.sh ~/.starshipz.sh;
ensure_zshrc "source ~/.starshipz.sh";
mkdir -p ~/.config;
ln -snf $COMMON_MNT/starship/starship.toml ~/.config/starship.toml

# Brootインストール
no broot && asdf_install broot latest https://github.com/cmur2/asdf-broot.git
mkdir -p ~/.config/broot;
ln -snf $UBUNTU_MNT/broot.toml ~/.config/broot/conf.toml;

# Neovim
no nvim && asdf_install neovim 0.9.4
ensure_bashrc 'alias vim=nvim'
ensure_zshrc 'alias vim=nvim'
mkdir -p ~/.config/nvim
ln -snf ${COMMON_MNT}/nvim/init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/nvim/lua
ln -snf ${UBUNTU_MNT}/nvim/clipboard.lua ~/.config/nvim/lua/clipboard.lua
ln -snf ${COMMON_MNT}/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
ln -snf ${COMMON_MNT}/nvim/lazy-lock.json ~/.config/nvim/lazy-lock.json
mkdir -p ~/.config/coc
ln -snf ${COMMON_MNT}/nvim/ultisnips ~/.config/coc/ultisnips


# GitUI
no gitui && asdf_install gitui latest
mkdir -p ~/.config/gitui;
ln -snf ${COMMON_MNT}/gitui/key_bindings.ron ~/.config/gitui/key_bindings.ron;
ln -snf $UBUNTU_MNT/bashrc/gitui.sh ~/.gitui.sh;
ensure_bashrc "source ~/.gitui.sh"
ensure_zshrc "source ~/.gitui.sh"

# LazyGit
no lazygit && asdf_install lazygit latest

# Node.js
no node && {
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git;
  asdf nodejs update-nodebuild;
  lts=$(asdf nodejs resolve lts --latest-available);
  asdf install nodejs ${lts};
  asdf global nodejs ${lts};
}

# Bun
no bun && asdf_install bun latest

# Deno
no deno && asdf_install deno latest https://github.com/asdf-community/asdf-deno.git

# Golang
no go && asdf_install golang latest https://github.com/asdf-community/asdf-golang.git
ensure_bashrc 'export GOPATH=$HOME/go'
ensure_bashrc 'export PATH=$PATH:$GOPATH/bin'
ensure_zshrc 'export GOPATH=$HOME/go'
ensure_zshrc 'export PATH=$PATH:$GOPATH/bin'

# Python
no python3.11 && asdf_install python 3.11.6
no python3.12 && asdf_install python 3.12.0

# Java
no java && asdf_install java latest:corretto-21 https://github.com/halcyon/asdf-java.git

# ripgrep
no rg && asdf_install ripgrep latest

# bat
no bat && asdf_install bat latest

# jq
no jq && asdf_install jq latest

# zoxide
no zoxide && asdf_install zoxide latest https://github.com/nyrst/asdf-zoxide.git
ln -snf $UBUNTU_MNT/bashrc/zoxide.sh ~/.zoxide.sh;
ensure_bashrc "source ~/.zoxide.sh";
ln -snf $UBUNTU_MNT/zshrc/zoxide.sh ~/.zoxidez.sh;
ensure_zshrc "source ~/.zoxidez.sh";

# eza
no eza && asdf_install eza latest
ln -snf $UBUNTU_MNT/bashrc/eza.sh ~/.eza.sh;
ensure_bashrc "source ~/.eza.sh";
ensure_zshrc "source ~/.eza.sh";

# fzf
no fzf && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
ln -snf $UBUNTU_MNT/bashrc/fzf.sh ~/.fzf.sh;
ensure_bashrc "source ~/.fzf.sh";
ensure_zshrc "source ~/.fzf.sh";

# delta
no delta && asdf_install delta latest https://github.com/andweeb/asdf-delta.git

# git-graph
no git-graph && {
  wget https://github.com/mlange-42/git-graph/releases/download/0.5.3/git-graph-0.5.3-linux-amd64.tar.gz -O /tmp/git-graph.tar.gz;
  sudo tar xvf /tmp/git-graph.tar.gz -C /usr/local/bin/;
}

# gowl
no gowl && {
  wget https://github.com/tadashi-aikawa/gowl/releases/download/v0.9.1/gowl-v0.9.1-x86_64-linux.tar.gz -O /tmp/gowl.tar.gz;
  sudo tar xvf /tmp/gowl.tar.gz -C /usr/local/bin/ --strip-components 2
}

# awscli
no awscli && asdf_install awscli 2.13.33 # 2.13.34が動かないので

# Task
no task && asdf_install task latest

# watchexec
no watchexec && asdf_install watchexec latest

# After
echo "Run broot"
echo "Run nvim"
echo "Run . ~/.fzf/install"
