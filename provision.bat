@echo off

set UBUNTU_MNT=%USERPROFILE%\Dropbox\ubuntu-mnt
set WINDOWS_MNT=%USERPROFILE%\Dropbox\windows-mnt

echo ------------------
echo Install
echo ------------------

cinst /y .\packages.config

echo Manually!!  Tablacus Explorer

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

echo ------------------
echo Homedir
echo ------------------

call :link_windows_home .bashrc
call :link_windows_home .minttyrc
call :link_windows_home .vimrc

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
