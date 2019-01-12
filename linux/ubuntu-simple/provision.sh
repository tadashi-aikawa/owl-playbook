#!/bin/bash

set -eu

cd /tmp

function info() {
  echo "□ ${1}"
}

function success() {
  echo "✅ ${1}"
}

function warn() {
  echo "⚠ ${1}"
}

function pip_install() {
  local name="$1"

  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "┃ Install ${name}"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  pip install ${name}
  success "★ All good!!"
}

function apt_install() {
  local name="$1"

  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "┃ [apt] Install ${name}"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  apt-get install -y ${name}
  success "★ All good!!"
}

function wget_install() {
  local name="$1"
  local url="$2"
  local check_command="${3:-'pwd'}"
  local skip_if_expected="${4:-'null'}"

  local dst=/usr/local/bin/${name}

  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "┃ [wget] Install ${name}"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [[ $(eval ${check_command}) =~ ${skip_if_expected} ]]; then
    warn "Skip install ${name} because \`${check_command}\` =~ \"${skip_if_expected}\""
    return
  fi

  info "Download ${name} from ${url}."
  wget -q "${url}" -O ${name}
  success "Download ${name}."

  info "Move ${name} to ${dst}."
  mv ${name} ${dst}
  chmod +x ${dst}
  success "★ All good!!"
}

function github_install() {
  local name="$1"
  local url="$2"
  local from="$3"
  local check_command="${4:-'pwd'}"
  local skip_if_expected="${5:-'null'}"

  local targz=${name}.tar.gz
  local dst=/usr/local/bin/${name}

  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "┃ [GitHub] Install ${name}"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [[ $(eval ${check_command}) =~ ${skip_if_expected} ]]; then
    warn "Skip install ${name} because \`${check_command}\` =~ \"${skip_if_expected}\""
    return
  fi

  info "Download ${targz} from ${url}."
  wget -q "${url}" -O ${targz}
  success "Download ${targz}."

  info "Extract ${targz}."
  tar zfx ${targz}
  success "Extract ${targz}."

  info "Move ${name} from ${from} to ${dst}."
  mv ${from} ${dst}
  chmod +x ${dst}
  success "★ All good!!"
}


#==============================================================================

# gowl
github_install gowl \
  "https://github.com/tadashi-aikawa/gowl/releases/download/v0.5.2/gowl-0.5.2-x86_64-linux.tar.gz" \
  "dist/*" \
  "gowl -V | head -1" \
  "0.5.2"

# bat
github_install bat \
  "https://github.com/sharkdp/bat/releases/download/v0.9.0/bat-v0.9.0-x86_64-unknown-linux-musl.tar.gz" \
  "bat-*-unknown-linux-musl/bat" \
  "bat -V" \
  "bat 0.9.0"

# fd
github_install fd \
  "https://github.com/sharkdp/fd/releases/download/v7.2.0/fd-v7.2.0-x86_64-unknown-linux-musl.tar.gz" \
  "fd-*-unknown-linux-musl/fd" \
  "fd -V" \
  "fd 7.2.0"

# ripgrep
github_install rg \
  "https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz" \
  "ripgrep-*-unknown-linux-musl/rg" \
  "rg -V" \
  "ripgrep 0.10.0"

# z
wget_install z \
  "https://raw.githubusercontent.com/rupa/z/master/z.sh" \
  "which z" \
  "/usr/local/bin/z"

# pip
apt_install python-pip
# tree
apt_install tree

# awscli
pip_install awscli

# node/npm (必要なら)
# apt-get install -y nodejs npm
# npm install n -g
# n lts
# ln -sf /usr/local/bin/node /usr/bin/node

# Uninstall nano

dpkg -P nano

