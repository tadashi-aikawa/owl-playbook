#!/bin/bash

set -eu

function show_usage() {
  echo "
Usages:
  toki bun <path>:        BunとBiomeのプロジェクトSandboxを作成します
  toki node <path>:       Node.jsとTypeScript/PrettierのプロジェクトSandboxを作成します
  toki deno <path>:       DenoのプロジェクトSandboxを作成します
  toki vue <path>:        Vue.js/Node.jsのプロジェクトSandboxを作成します
  toki nuxt <path>:       Nuxt/BunのプロジェクトSandboxを作成します
  toki tailwind <path>:   TailwindCSS + Vue + BunのプロジェクトSandboxを作成します
  toki go <path>:         GoプロジェクトのSandboxを作成します
  toki rust <path>:       RustプロジェクトのSandboxを作成します
  toki python <path>:     PythonプロジェクトのSandboxを作成します

  toki status:           関連するGitリポジトリの状態を取得します
  toki pull:             関連するGitリポジトリをすべてpullします
  toki update:           関連するGitリポジトリを最新化し、owl-playbookのprovisioningをします

  toki -h|--help|help: ヘルプを表示します
  "
}

command="${1:-}"

if [[ $command =~ ^(-h|--help|help|)$ ]]; then
  echo "『いったはずだ あなたのすべてをめざしたと!!』"
  show_usage
  exit 0
fi

shift

# -------------------------------------------
# BunとBiomeのプロジェクトSandboxを作成します
# -------------------------------------------
if [[ $command == "bun" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  bun init . -y
  bun add -d @biomejs/biome
  bun biome init

  echo "
🚀 Try

$ cd ${path}
$ bun --hot .
"
  exit 0
fi

# -------------------------------------------------------------
# Node.jsとTypeScript/PrettierのプロジェクトSandboxを作成します
# -------------------------------------------------------------
if [[ $command == "node" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  npm init -y
  npm i -D typescript @fsouza/prettierd prettier-plugin-organize-imports @tsconfig/recommended
  npm pkg set scripts.dev="tsc -w"
  npm pkg set scripts.start="node --watch *.js"

  cat >tsconfig.json <<'EOF'
{
  "extends": "@tsconfig/recommended/tsconfig.json"
}
EOF

  cat >.prettierrc.json <<'EOF'
{
  "plugins": ["prettier-plugin-organize-imports"]
}
EOF

  cat >index.ts <<'EOF'
function sum(x: number, y: number): number {
  return x + y;
}

function main() {
  var a = 1;
  var b = 10;
  console.log(`sum(a, b): ${sum(a, b)}`);
}

main();
EOF

  echo "
🚀 Try

$ cd ${path}

$ npm run dev
and
$ npm run start
"
  exit 0
fi

# -------------------------------------------
# DenoのプロジェクトSandboxを作成します
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

# -------------------------------------------
# Vue.js/Node.jsのプロジェクトSandboxを作成します
# -------------------------------------------
if [[ $command == "vue" ]]; then
  path="${1:?'pathは必須です'}"

  npm create vue@latest "${path}"
  cd "$path"
  npm i
  echo "
🚀 Try

$ cd ${path}
$ npm run dev
"
  exit 0

fi

# -------------------------------------------
# Nuxt/BunのプロジェクトSandboxを作成します
# -------------------------------------------
if [[ $command == "nuxt" ]]; then
  path="${1:?'pathは必須です'}"

  bun x nuxi@latest init "${path}"
  cd "$path"
  bun add --optional typescript
  mkdir pages
  echo "
🚀 Try

$ cd ${path}
$ bun dev -o
"
  exit 0

fi

# -------------------------------------------
# TailwindCSS + Vue + BunのプロジェクトSandboxを作成します
# -------------------------------------------

if [[ $command == "tailwind" ]]; then
  path="${1:?'pathは必須です'}"

  # https://tailwindcss.tw/docs/guides/vite
  bun create vite "${path}" --template vue-ts
  cd "${path}"
  bun i
  bun add --dev tailwindcss postcss autoprefixer
  bun x tailwindcss init -p

  cat <<EOL >tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOL

  cat <<EOL >./src/style.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOL

  cat <<EOL >./src/App.vue
<template>
  <div class="flex flex-col justify-center items-center w-screen h-screen">
    <span class="text-red-500 text-5xl">Title</span>
  </div>
</template>
EOL

  echo "
🚀 Try

$ cd ${path}
$ bun dev
"
  exit 0

fi

# -------------------------------------------
# GoプロジェクトのSandboxを作成します
# -------------------------------------------
if [[ $command == "go" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  go mod init sandbox/"${path}"
  go install github.com/air-verse/air@latest

  cat >main.go <<'EOF'
package main

import (
	"log"
)

func sum(x int, y int) int {
	return x + y
}

func main() {
	total := sum(1, 10)
	log.Printf("x + y = %d", total)
}
EOF

  echo "
🚀 Try

$ cd ${path}
$ air
"
  exit 0
fi

# -------------------------------------------
# RustプロジェクトのSandboxを作成します
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
# PythonプロジェクトのSandboxを作成します
# -------------------------------------------
if [[ $command == "python" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  python -m venv .venv
  cat >main.py <<'EOF'
def main():
    print("Hello python!!")


if __name__ == "__main__":
    main()
EOF

  echo "
🚀 Try

$ cd ${path}
$ source .venv/bin/activate
$ python main.py
"
  exit 0
fi

# -------------------------------------------
# 関連するGitリポジトリの状態を取得します
# -------------------------------------------
if [[ $command == "status" ]]; then
  GITHUB_AUTHOR_DIR=$HOME/git/github.com/tadashi-aikawa
  echo "--- 🦉 owl-playbook ---"
  cd "$GITHUB_AUTHOR_DIR/owl-playbook" && git status -s
  echo "--- 🍁 carnelian ---"
  cd "$GITHUB_AUTHOR_DIR/carnelian" && git status -s
  echo "--- 🐦 Fenice ---"
  cd "$GITHUB_AUTHOR_DIR/fenice" && git status -s
  exit 0
fi

function pull() {
  GITHUB_AUTHOR_DIR=$HOME/git/github.com/tadashi-aikawa
  echo "--- 🦉 owl-playbook ---"
  cd "$GITHUB_AUTHOR_DIR/owl-playbook" && git pull
  echo "--- 🍁 carnelian ---"
  cd "$GITHUB_AUTHOR_DIR/carnelian" && git pull
  echo "--- 🐦 Fenice ---"
  cd "$GITHUB_AUTHOR_DIR/fenice" && git pull
}

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
if [[ $command == "update" ]]; then
  pull
  cd "$GITHUB_AUTHOR_DIR/owl-playbook"
  bash ./linux/provision.sh
  exit 0
fi

echo "『き..きかぬ  きかぬのだ!!』"
show_usage
