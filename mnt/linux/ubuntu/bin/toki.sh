#!/bin/bash

set -eu

_PATH=$(readlink -f "${BASH_SOURCE:-$0}")
DIR_PATH=$(dirname "$_PATH")
TEMPLATE_DIR="${DIR_PATH}/template"

function show_usage() {
  echo "
Usages:
  toki <Target> <path>:  Sandbox環境を作成します

  toki status:           関連するGitリポジトリの状態を取得します
       st
  toki pull:             関連するGitリポジトリをすべてpullします
  toki update:           関連するGitリポジトリを最新化し、owl-playbookのprovisioningをします
       up

  toki -h|--help|help: ヘルプを表示します

-----------------
Available targets
-----------------
  | Target   | Language | Runtime    | PM    | Framework / Lib    | Linter    | Formatter |
  | -------- | -------- | ---------- | ----- | ------------------ | --------- | --------- |
  | node     | TS       | Node       | npm   | -                  | -         | prettierd |
  | pnpm     | TS       | tsx(Node)  | pnpm  | -                  | Biome     | Biome     |
  | deno     | TS       | Deno       | Deno  | -                  | Deno      | Deno      |
  | bun      | TS       | Bun        | Bun   | -                  | Biome     | Biome     |
  | jest     | TS       | Node       | pnpm  | Jest               | Biome     | Biome     |
  | vue      | TS or JS | Bun        | Bun   | Vue                | ?(ESLint) | prettierd |
  | nuxt     | TS       | *          | *     | Nuxt               | -         | prettierd |
  | tailwind | TS       | Bun        | Bun   | Vue + TailwindCSS  | -         | prettierd |
  | go       | Go       | -          | Go    | air                | -         | -         |
  | go-sqlx  | Go       | -          | Go    | sqlx + mysql + air | -         | -         |
  | rust     | Rust     | -          | Cargo | -                  | -         | -         |
  | python   | Python   | Virtualenv | Pip   | -                  | -         | -         |
  | nvim     | Lua      | Lua        |       | nvim               | -         | -         |
  | bash     | Bash     | Bash       |       | -                  | -         | -         |
  "
}

command="${1:-}"

if [[ $command =~ ^(-h|--help|help|)$ ]]; then
  echo "『いったはずだ あなたのすべてをめざしたと!!』"
  show_usage
  exit 0
fi

shift

function print_with_width() {
  text="$1"
  width=$2

  text_length=$(echo -n "$text" | awk '{print length()}')
  left_padding=$(((width - text_length) / 2))
  right_padding=$((width - text_length - left_padding))

  printf "%${left_padding}s%s%${right_padding}s" "" "$text" ""
}

function section() {
  echo ""
  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
  printf "┃ "
  print_with_width "$1" 40
  printf " ┃\n"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
}

# -------------------------------------------
# bun
# -------------------------------------------
if [[ $command == "bun" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  bun init . -y
  bun add -d @biomejs/biome
  bun biome init
  jq '.linter.rules.correctness.noUnusedImports|="warn"' <biome.json >biome.json.tmp
  mv biome.json.tmp biome.json

  echo "
🚀 Try

$ cd ${path}
$ bun --hot .
"
  exit 0
fi

# -------------------------------------------------------------
# node
# -------------------------------------------------------------
if [[ $command == "node" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  npm init -y
  npm i -D typescript @fsouza/prettierd prettier-plugin-organize-imports @tsconfig/recommended

  npm pkg set scripts.dev="tsc -w"
  npm pkg set scripts.start="node --watch *.js"

  cp -r "${TEMPLATE_DIR}"/node/* .

  echo "
🚀 Try

$ cd ${path}

$ npm run dev
and
$ npm run start
"
  exit 0
fi

# -------------------------------------------------------------
# pnpm
# -------------------------------------------------------------
if [[ $command == "pnpm" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  npm init -y
  corepack enable pnpm
  pnpm add -D typescript tsx @types/node @tsconfig/recommended @biomejs/biome

  pnpm exec biome init
  jq '.linter.rules.correctness.noUnusedImports|="warn"' <biome.json >biome.json.tmp
  mv biome.json.tmp biome.json

  pnpm pkg set scripts.dev="tsx watch ./index.ts"
  pnpm pkg set scripts.check="tsc --noEmit --watch"

  cp -r "${TEMPLATE_DIR}"/pnpm/* .

  echo "
🚀 Try

$ cd ${path}

$ pnpm dev
and
$ pnpm typecheck
"
  exit 0
fi

# -------------------------------------------
# deno
# -------------------------------------------
if [[ $command == "deno" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  deno init
  echo "
🚀 Try

$ cd ${path}
$ deno test
"
  exit 0
fi

# -------------------------------------------------------------
# jest
# -------------------------------------------------------------
if [[ $command == "jest" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  npm init -y
  corepack enable pnpm
  pnpm add -D typescript @tsconfig/recommended @biomejs/biome \
    jest babel-jest @babel/core @babel/preset-env \
    @babel/preset-typescript @jest/globals

  pnpm exec biome init
  jq '.linter.rules.correctness.noUnusedImports|="warn"' <biome.json >biome.json.tmp
  mv biome.json.tmp biome.json

  pnpm pkg set scripts.test="jest"
  pnpm pkg set scripts.test:watch="jest --watchAll"

  cp -r "${TEMPLATE_DIR}"/jest/* .

  echo "
🚀 Try

$ cd ${path}

$ pnpm test
or
$ pnpm test:watch
"
  exit 0
fi

# -------------------------------------------
# vue
# -------------------------------------------
if [[ $command == "vue" ]]; then
  path="${1:?'pathは必須です'}"

  bun create vue@latest "${path}"
  cd "$path"

  bun add -D @fsouza/prettierd prettier-plugin-organize-imports

  cp -r "${TEMPLATE_DIR}"/vue/* .

  bun i

  echo "
🚀 Try

$ cd ${path}
$ bun dev
"
  exit 0

fi

# -------------------------------------------
# nuxt
# -------------------------------------------
if [[ $command == "nuxt" ]]; then
  path="${1:?'pathは必須です'}"

  bun x nuxi@latest init "${path}"
  cd "$path"
  bun add --optional typescript
  mkdir pages

  bun add -D @fsouza/prettierd prettier-plugin-organize-imports

  cp -r "${TEMPLATE_DIR}"/nuxt/* .

  echo "
🚀 Try

$ cd ${path}
$ bun dev -o
"
  exit 0

fi

# -------------------------------------------
# tailwind
# -------------------------------------------

if [[ $command == "tailwind" ]]; then
  path="${1:?'pathは必須です'}"

  # https://tailwindcss.tw/docs/guides/vite
  bun create vite "${path}" --template vue-ts
  cd "${path}"
  bun i
  bun add --dev tailwindcss postcss autoprefixer
  bun x tailwindcss init -p

  cp -r "${TEMPLATE_DIR}"/tailwind/* .

  echo "
🚀 Try

$ cd ${path}
$ bun dev
"
  exit 0

fi

# -------------------------------------------
# go
# -------------------------------------------
if [[ $command == "go" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  go mod init sandbox/"${path}"
  go install github.com/air-verse/air@latest

  cp -r "${TEMPLATE_DIR}"/go/* .

  echo "
🚀 Try

$ cd ${path}
$ air
"
  exit 0
fi

# -------------------------------------------
# go-sqlx
# -------------------------------------------
if [[ $command == "go-sqlx" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  go mod init sandbox/"${path}"
  go install github.com/air-verse/air@latest

  go get github.com/jmoiron/sqlx
  go get github.com/go-sql-driver/mysql

  cp -r "${TEMPLATE_DIR}"/go-sqlx/* .

  echo "
🚀 Try

$ cd ${path}
$ air
"
  exit 0
fi

# -------------------------------------------
# rust
# -------------------------------------------
if [[ $command == "rust" ]]; then
  path="${1:?'pathは必須です'}"

  cargo new "$path"

  echo "
🚀 Try

$ cd ${path}
$ cargo run
"
  exit 0
fi

# -------------------------------------------
# python
# -------------------------------------------
if [[ $command == "python" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  python -m venv .venv

  cp -r "${TEMPLATE_DIR}"/python/* .

  echo "
🚀 Try

$ cd ${path}
$ source .venv/bin/activate
$ python main.py
"
  exit 0
fi

# -------------------------------------------
# nvim
# -------------------------------------------
if [[ $command == "nvim" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"

  cp -r "${TEMPLATE_DIR}"/nvim/* .

  echo "
🚀 Try

$ cd ${path}
$ mise watch
"
  exit 0
fi

# -------------------------------------------
# bash
# -------------------------------------------
if [[ $command == "bash" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"

  cp -r "${TEMPLATE_DIR}"/bash/* .

  chmod +x main.sh

  echo "
🚀 Try

$ cd ${path}
$ mise watch
"
  exit 0
fi

#--- Git ---

function show_status() {
  git -c color.status=always status -bs | grep -Ev "##.+[^]]$" || echo ""
}

function pull() {
  GITHUB_AUTHOR_DIR=$HOME/git/github.com/tadashi-aikawa

  section "🦉 owlplaybook"
  cd "$GITHUB_AUTHOR_DIR/owl-playbook" && git pull
  section "👻 ghostwriter.nvim"
  cd "$GITHUB_AUTHOR_DIR/ghostwriter.nvim" && git pull
  section "👤 silhouette.nvim"
  cd "$GITHUB_AUTHOR_DIR/silhouette.nvim" && git pull
  section "💎 obsidian.nvim"
  cd "$GITHUB_AUTHOR_DIR/obsidian.nvim" && git pull
}

# -------------------------------------------
# 関連するGitリポジトリの状態を取得します
# -------------------------------------------

if [[ $command == "status" || $command == "st" ]]; then
  GITHUB_AUTHOR_DIR=$HOME/git/github.com/tadashi-aikawa

  section "🦉 owl-playbook"
  cd "$GITHUB_AUTHOR_DIR/owl-playbook" && show_status
  section "👻 ghostwriter.nvim"
  cd "$GITHUB_AUTHOR_DIR/ghostwriter.nvim" && show_status
  section "👤 silhouette.nvim"
  cd "$GITHUB_AUTHOR_DIR/silhouette.nvim" && show_status
  section "💎 obsidian.nvim"
  cd "$GITHUB_AUTHOR_DIR/obsidian.nvim" && show_status
  exit 0
fi

# -------------------------------------------
# 関連するGitリポジトリをすべてpullします
# -------------------------------------------
if [[ $command == "pull" ]]; then
  pull
  exit 0
fi

# -------------------------------------------
# 関連するGitリポジトリを最新化し、owl-playbookのprovisioningをします
# -------------------------------------------
if [[ $command == "update" || $command == "up" ]]; then
  pull
  cd "$GITHUB_AUTHOR_DIR/owl-playbook"
  bash ./linux/provision.sh
  exit 0
fi

echo "『き..きかぬ  きかぬのだ!!』"
show_usage
