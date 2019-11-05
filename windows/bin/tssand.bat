mkdir %1
cd %1
git init
mkdir src
touch src/index.ts src/index.spec.ts

npm init -y ^
  && npm i -D typescript ts-node prettier jest ts-jest @types/jest ^
  && npx tsc --init ^
  && npx ts-jest config:init ^
  && wget "https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore" -O .gitignore ^
  && echo /.idea >> .gitignore ^
  && wget https://gist.githubusercontent.com/tadashi-aikawa/697f228f7b0c1d333e15d887deff8a96/raw/298993fc3e0e9cbcbd08a3cca574a31a22937a49/.prettierrc.yaml ^
  && wget https://gist.githubusercontent.com/tadashi-aikawa/697f228f7b0c1d333e15d887deff8a96/raw/298993fc3e0e9cbcbd08a3cca574a31a22937a49/.editorconfig

