@echo off

set WINDOWS_MNT="%~dp0..\mnt\windows"
set COMMON_MNT="%~dp0..\mnt\common"

set ROAMING="%USERPROFILE%\AppData\Roaming"

rem :tmpを動かすことで実行開始箇所を制御. デバッグや動作確認用
goto :tmp

call :******************** Install by Chocolatey
call chocolatey\install.bat

call :******************** Install by Scoop
call scoop\install.bat

call :******************** Install by npm
call npm\install.bat

call :******************** Install Vagrant plugins
call vagrant\install.bat

call :******************** Install go tools
call go get -u github.com/tadashi-aikawa/gowl
call go get -u github.com/astaxie/bat
mv %GOPATH%\bin\bat.exe %GOPATH%\bin\http.exe

call :******************** IntelliJ IDEA

:tmp
set IDEA_DIR=IntelliJIdea2020.1

set IDEA_ORIGIN_CONFIG_DIR=%COMMON_MNT%\IntelliJIdea\config
set IDEA_CONFIG_DIR=%ROAMING%\JetBrains\%IDEA_DIR%

call :link_idea_dir colors
call :link_idea_dir keymaps
call :link_idea_dir templates
call :link_file %USERPROFILE%\.ideavimrc %COMMON_MNT%\IntelliJIdea\.ideavimrc

call :each link_idea_file idea-files.txt
goto :end

call :******************** VS Code

set VSCODE_ORIGIN_USER_DIR=%COMMON_MNT%\VSCode\User
set VSCODE_USER_DIR=%ROAMING%\Code\User

call :link_vscode_file keybindings.json
call :link_vscode_file settings.json
call :link_vscode_dir snippets
rem See https://blog.mamansoft.net/2018/09/17/vscode-satisfies-vimmer/
call :each vscode_extension_install vscode-extensions.txt

call :******************** Homedir
call :each link_windows_home windows-home-dots.txt


call :******************** Cmder

set CMDER_ORIGIN_CONFIG_DIR=%WINDOWS_MNT%\cmder\config
set OWL_CMDER_TOOLS_CONFIG_DIR=%WINDOWS_MNT%\cmder\owl-cmder-tools\config
set CMDER_CONFIG_DIR=C:\tools\Cmder\config

call :each link_cmder_file cmder-files.txt
call :each link_cmder_tools_file owl-cmder-tools-files.txt


call :******************** Keypirinha

set KEYPIRINHA_ORIGIN_DIR=%WINDOWS_MNT%\keypirinha
set KEYPIRINHA_DIR=%ROAMING%\Keypirinha

call :link_file %KEYPIRINHA_DIR%\User\Keypirinha.ini %KEYPIRINHA_ORIGIN_DIR%\User\Keypirinha.ini


call :******************** git config

git config --global core.preloadindex true
git config --global core.fscache true
git config --global core.autoCRLF false
git config --global merge.ff false
git config --global pull.ff only


call :******************** To be continued.. (Not administrator

echo Install Tablacus Explorer manually!
echo Clone...
echo   * spinal-reflex-bindings-template
echo   * keypirinha-OwlTodoist

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

:link_cmder_file
call :link_file %CMDER_CONFIG_DIR%\%1 %CMDER_ORIGIN_CONFIG_DIR%\%1
exit /b

REM submoduleのcmder-toolsにリンクする
:link_cmder_tools_file
call :link_file %CMDER_CONFIG_DIR%\%1 %OWL_CMDER_TOOLS_CONFIG_DIR%\%1
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

:each
@FOR /F "usebackq" %%t IN (`cat %2`) DO call :%1 %%t
exit /b

:********************
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ┃ %*
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
exit /b

REM 途中で止めたい場合はここに..
:end
