@echo off

set UBUNTU_MNT=%USERPROFILE%\Dropbox\ubuntu-mnt
set WINDOWS_MNT=%USERPROFILE%\Dropbox\windows-mnt

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
call code --install-extension eamodio.gitlens
call code --install-extension formulahendry.code-runner
call code --install-extension mechatroner.rainbow-csv
call code --install-extension ms-python.python
call code --install-extension patrys.vscode-code-outline
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

echo ------------------
echo Homedir
echo ------------------

call :link_windows_home .bashrc
call :link_windows_home .minttyrc
call :link_windows_home .vimrc

call :link_dir C:\tools\Cmder\config %WINDOWS_MNT%\cmder\config
call :link_file C:\tools\Cmder\bin\cdg.bat %WINDOWS_MNT%\cmder\bin\cdg.bat
call :link_file C:\tools\Cmder\bin\d.bat %WINDOWS_MNT%\cmder\bin\d.bat
call :link_file C:\tools\Cmder\bin\f.bat %WINDOWS_MNT%\cmder\bin\f.bat
call :link_file C:\tools\Cmder\bin\ff.bat %WINDOWS_MNT%\cmder\bin\ff.bat
call :link_file C:\tools\Cmder\bin\gitc.bat %WINDOWS_MNT%\cmder\bin\gitc.bat
call :link_file C:\tools\Cmder\bin\gitrc.bat %WINDOWS_MNT%\cmder\bin\gitrc.bat

echo ------------------------------------
echo To be continued.. (Not administrator
echo ------------------------------------

echo Install Tablacus Explorer manually!

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
