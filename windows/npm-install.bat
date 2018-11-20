@echo off

echo ------------------
echo npm
echo ------------------

npm install -global ^
    textlint ^
    textlint-rule-preset-ja-technical-writing ^
    textlint-filter-rule-comments ^
    textlint-filter-rule-whitelist ^
    npm-upgrade
