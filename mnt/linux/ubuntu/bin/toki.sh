#!/bin/bash

set -eu

function show_usage() {
  echo "
Usages:
  toki bun <path>:     BunとBiomeのプロジェクトSandboxを作成します
  toki node <path>:    Node.jsとTypeScript/PrettierのプロジェクトSandboxを作成します

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

  mkdir -p .vim
  cat > .vim/coc-settings.json << 'EOF'
  {
    "prettier.enable": false
  }
EOF

  # biome initの結果に変化があったら変更する
  cat > biome.json << 'EOF'
  {
    "$schema": "https://biomejs.dev/schemas/1.5.1/schema.json",
    "organizeImports": {
      "enabled": true
    },
    "linter": {
      "enabled": true,
      "rules": {
        "recommended": true
      }
    },
    "formatter": {
      "enabled": true,
      "indentStyle": "space"
    }
  }
EOF


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
  npm i -D typescript prettier @tsconfig/recommended
  npm pkg set scripts.dev="tsc && node ."

cat > tsconfig.json << 'EOF'
{
  "extends": "@tsconfig/recommended/tsconfig.json"
}
EOF

cat > index.ts << 'EOF'
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


echo "『き..きかぬ  きかぬのだ!!』"
show_usage
