set -eu

CURRENT_DIR_PATH=$(readlink -f "$(pwd)")

MNT="${CURRENT_DIR_PATH}/mnt"
COMMON_MNT="${MNT}/common"
LINUX_MNT="${MNT}/linux"
UBUNTU_MNT="${LINUX_MNT}/ubuntu"

# shellcheck disable=SC2034
# miseの-yフラグ省略
MISE_YES=1

# no cat && { catのインストール処理 }
function no() {
  echo "🔍 $1 コマンドの存在確認"
  ! command -v "$1" >/dev/null
}

# ~/.bashrcに引数と一致する文があることを保証します
# 既に存在すれば何もせず、存在しなければ最後に追記します
function ensure_bashrc() {
  local content="$1"

  if ! grep -qxF -- "$content" ~/.bashrc; then
    echo "$content" >>~/.bashrc
    echo "👍 '${content}' was added to .bashrc."
  else
    echo "👌 '${content}' is already present in .bashrc."
  fi
}

# ~/.zshrcに引数と一致する文があることを保証します
# 既に存在すれば何もせず、存在しなければ最後に追記します
function ensure_zshrc() {
  local content="$1"

  if ! grep -qxF -- "$content" ~/.zshrc; then
    echo "$content" >>~/.zshrc
    echo "👍 '${content}' was added to .zshrc."
  else
    echo "👌 '${content}' is already present in .zshrc."
  fi
}

#----------------------------------------------------------------------
# WSL
#----------------------------------------------------------------------
sudo ln -snf "$LINUX_MNT"/wsl.conf /etc/wsl.conf
# sleepで時刻stop対策
sudo mkdir -p /etc/systemd/system/systemd-timesyncd.service.d
sudo ln -snf "$LINUX_MNT"/systemd-timesyncd.service.d/override.conf /etc/systemd/system/systemd-timesyncd.service.d/override.conf

#----------------------------------------------------------------------
# 依存関係インストール
#----------------------------------------------------------------------
sudo apt-get update -y
# instead ntp
sudo apt-get install -y chrony
sudo systemctl enable chrony
sudo systemctl start chrony
# calendar
sudo apt-get install -y ncal
# watchexecで使用
sudo apt-get install -y libc6
# Neovimで使用
sudo apt-get install -y wl-clipboard
# nvim-treesitterで使用
sudo apt-get install -y build-essential
# Pythonで使用
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
# ffmpegで使用
sudo apt-get install -y \
  libx264-dev \
  libx265-dev \
  libnuma-dev \
  libvpx-dev

#----------------------------------------------------------------------
# Shell
#----------------------------------------------------------------------

# zsh
sudo apt-get install -y zsh zsh-autosuggestions
ensure_zshrc "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

#----------------------------------------------------------------------
# config / rc files / dot files
#----------------------------------------------------------------------

# gitconfig
ln -snf "$UBUNTU_MNT"/gitconfig ~/.gitconfig

# .inputrc
ln -snf "$UBUNTU_MNT"/inputrc ~/.inputrc

# .bashrc
ln -snf "$UBUNTU_MNT"/base.sh ~/.base.sh
ensure_bashrc "source ~/.base.sh"

# .zshrc
ln -snf "$UBUNTU_MNT"/zshrc/base.sh ~/.basez.sh
ensure_zshrc "source ~/.base.sh"
ensure_zshrc "source ~/.basez.sh"

#----------------------------------------------------------------------
# Runtime manager
#----------------------------------------------------------------------

# mise
no mise && {
  curl https://mise.jdx.dev/install.sh | sh
  # shellcheck disable=SC1091
  source "$UBUNTU_MNT"/bashrc/mise.sh
}
ln -snf "$UBUNTU_MNT"/bashrc/mise.sh ~/.mise.sh
ensure_bashrc "source ~/.mise.sh"
ln -snf "$UBUNTU_MNT"/zshrc/mise.sh ~/.misez.sh
ensure_zshrc "source ~/.misez.sh"

#----------------------------------------------------------------------
# Prompt
#----------------------------------------------------------------------

# Starship
mise use -g starship
ln -snf "$UBUNTU_MNT"/bashrc/starship.sh ~/.starship.sh
ensure_bashrc "source ~/.starship.sh"
ln -snf "$UBUNTU_MNT"/zshrc/starship.sh ~/.starshipz.sh
ensure_zshrc "source ~/.starshipz.sh"
mkdir -p ~/.config
ln -snf "$COMMON_MNT"/starship/starship.toml ~/.config/starship.toml

#----------------------------------------------------------------------
# Editor
#----------------------------------------------------------------------

# Neovim
mise use -g neovim
ensure_bashrc 'alias vim=nvim'
ensure_zshrc 'alias vim=nvim'
mkdir -p ~/.config/nvim
ln -snf "${COMMON_MNT}"/nvim/lua ~/.config/nvim/lua
ln -snf "${COMMON_MNT}"/nvim/init.lua ~/.config/nvim/init.lua
ln -snf "${COMMON_MNT}"/nvim/snippets ~/.config/nvim/snippets

#----------------------------------------------------------------------
# Languages / Runtimes / LSP
#----------------------------------------------------------------------

# Node.js
mise use -g node@22

# Bun
mise use -g bun

# Deno
# TODO: 2.1.7がリリースされるまで https://github.com/vim-denops/denops.vim/issues/433
mise use -g deno@2.1.5

# Golang
mise use -g go@1.22
mise use -g go@1.23
# shellcheck disable=SC2016
ensure_bashrc 'export GOPATH=$HOME/go'
# shellcheck disable=SC2016
ensure_bashrc 'export PATH=$PATH:$GOPATH/bin'
# shellcheck disable=SC2016
ensure_zshrc 'export GOPATH=$HOME/go'
# shellcheck disable=SC2016
ensure_zshrc 'export PATH=$PATH:$GOPATH/bin'
mise use -g gofumpt
mise use -g golangci-lint
mise x -- go install github.com/nametake/golangci-lint-langserver@latest

# Rust
mise use -g rust
rustup component add rust-analyzer

# Python
mise use -g python@3.12
mise use -g python@3.13
mise use -g npm:pyright
mise use -g ruff
mise use -g uv

# Bash
mise use -g npm:bash-language-server
mise use -g shellcheck
mise use -g shfmt

# Lua
mise use -g lua@5.1 # Neovim 0.10にあわせる
mise use -g lua-language-server
mise use -g stylua

# Prettier
mise use -g npm:@fsouza/prettierd
mise use -g npm:prettier # better-ts-errors.nvim で使う

# HTML/CSS/JSON LSP
mise use -g npm:vscode-langservers-extracted
mise use -g npm:@olrtg/emmet-language-server
mise use -g npm:@tailwindcss/language-server

# YAML
mise use -g npm:yaml-language-server

# TypeScript
mise use -g npm:typescript
mise use -g npm:typescript-language-server

# Vue
mise use -g npm:@vue/language-server

# Svelte
mise use -g npm:svelte-language-server

#----------------------------------------------------------------------
# TUI Tools
#----------------------------------------------------------------------

# Lazygit
mise use -g lazygit
ln -snf "${COMMON_MNT}"/lazygit/config.yml ~/.config/lazygit/config.yml

# Lazydocker
mise use -g lazydocker

# Lazysql
mise use -g go:github.com/jorgerojas26/lazysql@0.3.3

#----------------------------------------------------------------------
# CLI Tools
#----------------------------------------------------------------------

# fd
mise use -g fd

# ripgrep
mise use -g ripgrep

# bat
mise use -g bat

# dust
mise use -g dust

# xh
mise use -g xh

# jq
mise use -g jq

# bottom
mise use -g bottom

# zoxide
mise use -g zoxide
ln -snf "$UBUNTU_MNT"/bashrc/zoxide.sh ~/.zoxide.sh
ensure_bashrc "source ~/.zoxide.sh"
ln -snf "$UBUNTU_MNT"/zshrc/zoxide.sh ~/.zoxidez.sh
ensure_zshrc "source ~/.zoxidez.sh"

# eza
mise use -g eza
ln -snf "$UBUNTU_MNT"/bashrc/eza.sh ~/.eza.sh
ensure_bashrc "source ~/.eza.sh"
ensure_zshrc "source ~/.eza.sh"

# fzf
mise use -g fzf
ln -snf "$UBUNTU_MNT"/bashrc/fzf.sh ~/.fzf.sh
ensure_bashrc "source ~/.fzf.sh"
ensure_zshrc "source ~/.fzf.sh"

# delta
mise use -g delta

# git-graph
no git-graph && {
  wget https://github.com/mlange-42/git-graph/releases/download/0.5.3/git-graph-0.5.3-linux-amd64.tar.gz -O /tmp/git-graph.tar.gz
  sudo tar xvf /tmp/git-graph.tar.gz -C /usr/local/bin/
}

# gowl
no gowl && {
  wget https://github.com/tadashi-aikawa/gowl/releases/download/v0.9.1/gowl-v0.9.1-x86_64-linux.tar.gz -O /tmp/gowl.tar.gz
  sudo tar xvf /tmp/gowl.tar.gz -C /usr/local/bin/ --strip-components 2
}

# awscli
mise use -g awscli

# Task
mise use -g task

# watchexec
mise use -g watchexec

# Marp CLI
mise use -g marp-cli

# toki
ln -snf "$UBUNTU_MNT"/bin/toki.sh ~/.local/bin/toki

#----------------------------------------------------------------------
# Before terminate
#----------------------------------------------------------------------

# fzf
echo "Run ~/.local/share/mise/installs/fzf/latest/install"
# Neovim
echo "Run nvim"
