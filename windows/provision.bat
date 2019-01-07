@echo off

set UBUNTU_MNT="%USERPROFILE%\Box Sync\ubuntu-mnt"
set WINDOWS_MNT="%USERPROFILE%\Box Sync\windows-mnt"

echo ------------------
echo Install
echo ------------------

cinst /y .\packages.config
call scoop-install.bat
call npm-install.bat

echo ------------------
echo Vagrant
echo ------------------

vagrant plugin install vagrant-vbguest vagrant-disksize

echo ------------------
echo IntelliJ IDEA
echo ------------------

set IDEA_DIR=.IntelliJIdea2018.1

set IDEA_ORIGIN_CONFIG_DIR=%UBUNTU_MNT%\.IntelliJIdea\config
set IDEA_CONFIG_DIR=%USERPROFILE%\%IDEA_DIR%\config

call :link_idea_dir colors
call :link_idea_dir keymaps
call :link_idea_file options\editor.xml
call :link_idea_file options\colors.scheme.xml
call :link_idea_file options\ide.general.xml
call :link_idea_file options\keymap.xml
call :link_idea_file options\markdown.xml
call :link_idea_file options\vcs.xml
call :link_idea_file options\vim_settings.xml
call :link_file %USERPROFILE%\.ideavimrc %UBUNTU_MNT%\.ideavimrc


echo ------------------
echo VS Code
echo ------------------

set VSCODE_ORIGIN_USER_DIR=%UBUNTU_MNT%\.config\Code\User
set VSCODE_USER_DIR=%USERPROFILE%\AppData\Roaming\Code\User

call :link_vscode_file keybindings.json
call :link_vscode_file settings.json
call :link_vscode_dir snippets

rem See https://blog.mamansoft.net/2018/09/17/vscode-satisfies-vimmer/
call code --install-extension 2gua.rainbow-brackets
call code --install-extension MS-CEINTL.vscode-language-pack-ja
call code --install-extension PeterJausovec.vscode-docker
call code --install-extension bungcip.better-toml
call code --install-extension donjayamanne.githistory
call code --install-extension formulahendry.code-runner
call code --install-extension mechatroner.rainbow-csv
call code --install-extension ms-python.python
call code --install-extension quicktype.quicktype
call code --install-extension ryu1kn.edit-with-shell
call code --install-extension sgryjp.japanese-word-handler
call code --install-extension shuworks.vscode-table-formatter
call code --install-extension slevesque.vscode-autohotkey
call code --install-extension vscodevim.vim
call code --install-extension taichi.vscode-textlint
call code --install-extension robertohuertasm.vscode-icons
call code --install-extension shardulm94.trailing-spaces
call code --install-extension ms-vscode.cpptools
call code --install-extension eg2.tslint
call code --install-extension octref.vetur
call code --install-extension editorconfig.editorconfig
call code --install-extension patricklee.vsnotes

echo ------------------
echo Homedir
echo ------------------

call :link_windows_home .bashrc
call :link_windows_home .minttyrc
call :link_windows_home .vimrc
call :link_windows_home .vim

call :link_dir C:\tools\Cmder\config %WINDOWS_MNT%\cmder\config

echo ------------------------------------
echo git config
echo ------------------------------------

git config --global core.preloadindex true
git config --global core.fscache true
git config --global core.autoCRLF false

echo ------------------------------------
echo To be continued.. (Not administrator
echo ------------------------------------

echo Install Tablacus Explorer manually!
echo Install gowl (go get -u github.com/tadashi-aikawa/gowl)
echo Install owl-cmder-tool
echo Install spinal-reflex-bindings-template
echo Install Keypirinha (https://github.com/Keypirinha/Keypirinha/releases/download)

exit /b

rem ---------------------------------------------------------

:link_windows_home
call :link_file %USERPROFILE%\%1 %WINDOWS_MNT%\%1
exit /b

:link_idea_file
call :link_file %IDEA_CONFIG_DIR%\%1 %IDEA_ORIGIN_CONFIG_DIR%\%1
exit /b

:link_idea_dir
call :link_dir %IDEA_CONFIG_DIR%\%1 %IDEA_ORIGIN_CONFIG_DIR%\%1
exit /b

:link_vscode_file
call :link_file %VSCODE_USER_DIR%\%1 %VSCODE_ORIGIN_USER_DIR%\%1
exit /b

:link_vscode_dir
call :link_dir %VSCODE_USER_DIR%\%1 %VSCODE_ORIGIN_USER_DIR%\%1
exit /b

rem ----- common ------

:link_file
del %1
Mklink %1 %2
exit /b

:link_dir
rd /s /q %1
Mklink /D %1 %2
exit /b
