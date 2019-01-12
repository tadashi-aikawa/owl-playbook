@echo off

set WINDOWS_MNT="%~dp0..\mnt\windows"
set COMMON_MNT="%~dp0..\mnt\common"

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

set IDEA_ORIGIN_CONFIG_DIR=%COMMON_MNT%\.IntelliJIdea\config
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
call :link_file %USERPROFILE%\.ideavimrc %COMMON_MNT%\.IntelliJIdea\.ideavimrc


echo ------------------
echo VS Code
echo ------------------

set VSCODE_ORIGIN_USER_DIR=%COMMON_MNT%\VSCode\User
set VSCODE_USER_DIR=%USERPROFILE%\AppData\Roaming\Code\User

call :link_vscode_file keybindings.json
call :link_vscode_file settings.json
call :link_vscode_dir snippets

rem See https://blog.mamansoft.net/2018/09/17/vscode-satisfies-vimmer/
call :each vscode_extension_install vscode-extensions.txt


echo ------------------
echo Homedir
echo ------------------

call :link_windows_home .bashrc
call :link_windows_home .minttyrc
call :link_windows_home .vimrc
call :link_windows_home .vim

echo ------------------
echo Cmder
echo ------------------

set CMDER_ORIGIN_CONFIG_DIR=%WINDOWS_MNT%\cmder\config
set CMDER_CONFIG_DIR=C:\tools\Cmder\config

call :each link_cmder_file cmder-files.txt

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

:each
@FOR /F "usebackq" %%t IN (`cat %2`) DO call :%1 %%t
exit /b


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

:link_cmder_file
call :link_file %CMDER_CONFIG_DIR%\%1 %CMDER_ORIGIN_CONFIG_DIR%\%1
exit /b

:vscode_extension_install
call code --install-extension %1
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
