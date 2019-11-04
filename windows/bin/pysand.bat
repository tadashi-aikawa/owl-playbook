pip install black mypy pylint

mkdir %1
cd %1
git init
mkdir %1 tests
touch %1/main.py %1/__init__.py tests/test_main.py tests/__init__.py

pipenv --python 3.7
pipenv install -d pytest --skip-lock

wget "https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore" -O .gitignore
echo /.idea >> .gitignore

wget https://gist.githubusercontent.com/tadashi-aikawa/697f228f7b0c1d333e15d887deff8a96/raw/298993fc3e0e9cbcbd08a3cca574a31a22937a49/pyproject.toml
wget https://gist.githubusercontent.com/tadashi-aikawa/697f228f7b0c1d333e15d887deff8a96/raw/298993fc3e0e9cbcbd08a3cca574a31a22937a49/.editorconfig

pipenv --py

@echo off
echo ==========================
echo           IDEA
echo ==========================
echo.
echo ---- File Watchers -- black ----
echo File type: Python
echo     Scope: Current File
echo   Program: black
echo Arguments: \$FilePath\$
echo .
echo AdvancedOptions are all OFF!
echo .
echo .
echo ---- Test settings ----
echo 1. Run/Debug Configurations
echo 2. Python tests -- pytest
echo 3. Target = Custom
echo 4. Additional Argument = --doctest-modules --doctest-continue-on-failure -vv
echo 5. Working directory = \${test root}

