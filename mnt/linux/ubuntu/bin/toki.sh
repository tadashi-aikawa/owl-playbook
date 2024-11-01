#!/bin/bash

set -eu

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
  | pnpm     | TS       | Node       | pnpm  | -                  | Biome     | Biome     |
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

# -------------------------------------------------------------
# pnpm
# -------------------------------------------------------------
if [[ $command == "pnpm" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  npm init -y
  corepack use pnpm
  pnpm add -D typescript @tsconfig/recommended @biomejs/biome

  pnpm exec biome init
  jq '.linter.rules.correctness.noUnusedImports|="warn"' <biome.json >biome.json.tmp
  mv biome.json.tmp biome.json

  pnpm pkg set scripts.dev="tsc -w"
  pnpm pkg set scripts.start="node --watch *.js"

  cat >tsconfig.json <<'EOF'
{
  "extends": "@tsconfig/recommended/tsconfig.json"
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

$ pnpm dev
and
$ pnpm start
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
  corepack use pnpm
  pnpm add -D typescript @tsconfig/recommended @biomejs/biome \
    jest babel-jest @babel/core @babel/preset-env \
    @babel/preset-typescript @jest/globals

  pnpm exec biome init
  jq '.linter.rules.correctness.noUnusedImports|="warn"' <biome.json >biome.json.tmp
  mv biome.json.tmp biome.json

  pnpm pkg set scripts.test="jest"
  pnpm pkg set scripts.test:watch="jest --watchAll"

  cat >tsconfig.json <<'EOF'
{
  "extends": "@tsconfig/recommended/tsconfig.json"
}
EOF

  cat >babel.config.js <<'EOF'
module.exports = {
  presets: [
      ['@babel/preset-env', {targets: {node: 'current'}}],
      '@babel/preset-typescript'
  ],
};
EOF

  cat >index.test.ts <<'EOF'
import { describe, expect, test } from "@jest/globals";

function sum(x: number, y: number): number {
  return x + y;
}

describe("sum", () => {
  test("1 + 1 = 2", () => {
    expect(sum(1, 1)).toBe(2);
  });
});
EOF

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
  cat >.prettierrc.json <<'EOF'
{
  "plugins": ["prettier-plugin-organize-imports"]
}
EOF

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
  cat >.prettierrc.json <<'EOF'
{
  "plugins": ["prettier-plugin-organize-imports"]
}
EOF

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
# go
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

  cat >main.go <<'EOF'
package main

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

func PrintPrettyJson(obj interface{}) {
	r, _ := json.MarshalIndent(obj, "", "  ")
	fmt.Println(string(r))
}

type record struct {
	Id   int    `db:"id"`
	Name string `db:"name"`
}

func initDB() *sqlx.DB {
	jst := time.FixedZone("Asia/Tokyo", 9*60*60)
	cfg := mysql.Config{
		User:      "foo",
		Passwd:    "bar",
		Net:       "tcp",
		Addr:      "127.0.0.1:3366",
		DBName:    "TESTDB",
		ParseTime: true,
		Loc:       jst,
	}
	dsn := cfg.FormatDSN()

	db, err := sqlx.Open("mysql", dsn)
	if err != nil {
		panic(err)
	}

	return db
}

func main() {
	db := initDB()

	var results []record
	err := db.Select(&results, `
SELECT id, name from members
;`)
	if err != nil {
		panic(err)
	}

	PrintPrettyJson(results)
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
# nvim
# -------------------------------------------
if [[ $command == "nvim" ]]; then
  path="${1:?'pathは必須です'}"

  mkdir -p "$path"
  cd "$path"
  cat >main.lua <<'EOF'
vim.notify("aa" .. "bb")
EOF
  cat >.mise.toml <<'EOF'
[tasks.default]
run = "nvim -l main.lua"
EOF

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

  cat >.mise.toml <<'EOF'
[tasks.default]
run = "./main.sh"
EOF

  cat >main.sh <<'EOF'
#!/bin/bash

echo "hogehoge"
EOF
  chmod +x main.sh

  echo "
🚀 Try

$ cd ${path}
$ mise watch
"
  exit 0
fi

# -------------------------------------------
# 関連するGitリポジトリの状態を取得します
# -------------------------------------------
if [[ $command == "status" || $command == "st" ]]; then
  GITHUB_AUTHOR_DIR=$HOME/git/github.com/tadashi-aikawa

  section "🦉 owl-playbook"
  cd "$GITHUB_AUTHOR_DIR/owl-playbook" && git status -s
  section "👻 ghostwriter.nvim"
  cd "$GITHUB_AUTHOR_DIR/ghostwriter.nvim" && git status -s
  section "👤 silhouette.nvim"
  cd "$GITHUB_AUTHOR_DIR/silhouette.nvim" && git status -s
  section "💎 obsidian.nvim"
  cd "$GITHUB_AUTHOR_DIR/obsidian.nvim" && git status -s
  exit 0
fi

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
