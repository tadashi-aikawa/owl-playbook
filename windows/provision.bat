@echo off

set WINDOWS_MNT="%~dp0..\mnt\windows"
set COMMON_MNT="%~dp0..\mnt\common"

set ROAMING="%USERPROFILE%\AppData\Roaming"
set LOCAL="%USERPROFILE%\AppData\Local"

rem :tmpを動かすことで実行開始箇所を制御. デバッグや動作確認用
goto :tmp


call :******************** IntelliJ IDEA

set IDEA_DIR=IntelliJIdea2020.1

set IDEA_ORIGIN_CONFIG_DIR=%COMMON_MNT%\IntelliJIdea\config
set IDEA_CONFIG_DIR=%ROAMING%\JetBrains\%IDEA_DIR%

call :link_idea_dir colors
call :link_idea_dir keymaps
call :link_idea_dir templates
call :link_idea_dir codestyles
call :link_file %USERPROFILE%\.ideavimrc %COMMON_MNT%\IntelliJIdea\.ideavimrc

call :each link_idea_file idea-files.txt


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

:tmp
call :******************** PowerShell

set POWER_SHELL_ORIGIN_DIR=%WINDOWS_MNT%\power-shell
set POWER_SHELL_DIR=%USERPROFILE%\Documents\WindowsPowerShell

call :link_file %POWER_SHELL_DIR%\Microsoft.PowerShell_profile.ps1 %POWER_SHELL_ORIGIN_DIR%\Microsoft.PowerShell_profile.ps1


call :******************** Terminal

set TERMINAL_ORIGIN_DIR=%WINDOWS_MNT%\terminal
call :link_file "%LOCAL%\Microsoft\Windows Terminal\settings.json" %TERMINAL_ORIGIN_DIR%\LocalState\settings.json
rem call :******************** Keypirinha

rem set KEYPIRINHA_ORIGIN_DIR=%WINDOWS_MNT%\keypirinha
rem set KEYPIRINHA_DIR=%ROAMING%\Keypirinha

rem call :link_file %KEYPIRINHA_DIR%\User\Keypirinha.ini %KEYPIRINHA_ORIGIN_DIR%\User\Keypirinha.ini


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

goto :end
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
@FOR /F "usebackq" %%t IN (`bat %2`) DO call :%1 %%t
exit /b

:********************
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ┃ %*
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
exit /b

REM 途中で止めたい場合はここに..
:end
