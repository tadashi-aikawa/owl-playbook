#!/bin/bash

set -eu

function show_usage() {
  echo "
Usages:
  toki bun <path>:   BunとBiomeのプロジェクトSandboxを作成します
  toki node <path>:  Node.jsとTypeScript/PrettierのプロジェクトSandboxを作成します
  toki go <path>:    GoプロジェクトとairのSandboxを作成します

  toki pull:         関連するGitリポジトリをすべてpullします

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
$ bun .
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
  npm i -D typescript prettier prettier-plugin-organize-imports @tsconfig/recommended
  npm pkg set scripts.dev="tsc && node ."

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
  go install github.com/cosmtrek/air@latest

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
# 関連するGitリポジトリをすべてpullします
# -------------------------------------------
if [[ $command == "pull" ]]; then
  GITHUB_AUTHOR_DIR=$HOME/git/github.com/tadashi-aikawa
  echo "--- 🦉owl-playbook ---"
  cd "$GITHUB_AUTHOR_DIR/owl-playbook" && git pull
  echo "--- 🍁carnelian ---"
  cd "$GITHUB_AUTHOR_DIR/carnelian" && git pull
  exit 0
fi

echo "『き..きかぬ  きかぬのだ!!』"
show_usage
