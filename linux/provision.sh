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

function mise_no() {
  echo "🔍 $1 コマンドの存在確認"
  ! which "$1" >/dev/null
}

# miseでインストールされている全Node.jsバージョンでインストール
# $1: インストール対象, $2: コマンド名($1と異なる場合のみ)
function npm_install() {
  target="$1"
  command=${2:-${target}}

  mise use -g node@18
  mise_no "${command}" && mise x -- npm i -g "${target}"
  mise use -g node@18.15.0
  mise_no "${command}" && mise x -- npm i -g "${target}"
  mise use -g node@20
  mise_no "${command}" && mise x -- npm i -g "${target}"

  return 0
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
# 環境変数
#----------------------------------------------------------------------

# xterm-256colorをベースに波線などのエスケープに対応した独自のterminfo
ensure_bashrc 'export TERM="owlterm-256color"'
ensure_zshrc 'export TERM="owlterm-256color"'

#----------------------------------------------------------------------
# 依存関係インストール
#----------------------------------------------------------------------
sudo apt-get update -y
# Neovimで使用
sudo apt-get install -y wl-clipboard
# nvim-treesitterで使用
sudo apt-get install -y build-essential
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
# TUI Tools
#----------------------------------------------------------------------

# Broot
mise plugin install https://github.com/cmur2/asdf-broot.git
mise use -g broot
mkdir -p ~/.config/broot
ln -snf "$UBUNTU_MNT"/broot.toml ~/.config/broot/conf.toml
ln -snf "$UBUNTU_MNT"/broot.nvim.toml ~/.config/broot/conf.nvim.toml

# LazyGit
mise use -g lazygit
ln -snf "${COMMON_MNT}"/lazygit/config.yml ~/.config/lazygit/config.yml

# LazyDocker
mise plugin install https://github.com/comdotlinux/asdf-lazydocker.git
mise use -g lazydocker

#----------------------------------------------------------------------
# Languages / Runtimes / LSP
#----------------------------------------------------------------------

# Node.js
mise use -g node@18
mise use -g node@20

# Bun
mise use -g bun

# Deno
mise use -g deno

# Golang
mise install go@1.20 go@1.21
mise use -g go@1.22
# shellcheck disable=SC2016
ensure_bashrc 'export GOPATH=$HOME/go'
# shellcheck disable=SC2016
ensure_bashrc 'export PATH=$PATH:$GOPATH/bin'
# shellcheck disable=SC2016
ensure_zshrc 'export GOPATH=$HOME/go'
# shellcheck disable=SC2016
ensure_zshrc 'export PATH=$PATH:$GOPATH/bin'
mise use --global gofumpt
mise use -g golangci-lint
mise x -- go install github.com/nametake/golangci-lint-langserver@latest

# Python
mise use -g python@3.12
npm_install pyright
no ruff-lsp && mise x -- pip install ruff-lsp

# Bash
npm_install bash-language-server
mise use -g shellcheck
mise use -g shfmt

# Lua
mise use --global lua-language-server
mise use --global stylua

# Prettier
npm_install @fsouza/prettierd prettierd

# HTML/CSS/JSON LSP
npm_install vscode-langservers-extracted vscode-css-language-server
npm_install vscode-langservers-extracted vscode-json-language-server
npm_install @olrtg/emmet-language-server emmet-language-server
npm_install @tailwindcss/language-server tailwindcss-language-server

# YAML
npm_install yaml-language-server

# TypeScript
npm_install typescript tsc
npm_install typescript-language-server

# Vue
npm_install @vue/language-server vue-language-server

# Svelte
npm_install svelte-language-server svelteserver

# Markdown
no marksman && {
  sudo wget https://github.com/artempyanykh/marksman/releases/download/2023-12-09/marksman-linux-x64 -O /usr/local/bin/marksman
  sudo chmod +x /usr/local/bin/marksman
}

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

# jq
mise use -g jq

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

# toki
ln -snf "$UBUNTU_MNT"/bin/toki.sh ~/.local/bin/toki

#----------------------------------------------------------------------
# Before terminate
#----------------------------------------------------------------------

# Broot
echo "Run broot"
# fzf
echo "Run ~/.local/share/mise/installs/fzf/latest/install"
# Neovim
echo "Run nvim"
# Poetry
echo mise use -g poetry
echo mise x -- poetry config virtualenvs.in-project true
