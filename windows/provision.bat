@echo off

set WINDOWS_MNT="%~dp0..\mnt\windows"
set COMMON_MNT="%~dp0..\mnt\common"

set ROAMING="%USERPROFILE%\AppData\Roaming"
set LOCAL="%USERPROFILE%\AppData\Local"
set SCOOP="%USERPROFILE%\scoop"

rem :tmpを動かすことで実行開始箇所を制御. デバッグや動作確認用
goto :tmp
:tmp

call :******************** Obsidian

set OBSIDIAN_ORIGIN_DIR="%USERPROFILE%\Box\obsidian\minerva"
set OBSIDIAN_DIR="%USERPROFILE%\work\minerva"
set OBSIDIAN_CONFIG_DIR="%OBSIDIAN_DIR%\.obsidian"

rem sync.jsonとworkspace以外はすべて
call :link_obsidian_file obsidian.css
call :link_obsidian_file publish.css
call :link_obsidian_file publish.js
call :link_obsidian_file favicon.ico
rem Boxではドットファイルを同期できないため
call :link_file %OBSIDIAN_DIR%\.obsidian.vimrc %OBSIDIAN_ORIGIN_DIR%\obsidian.vimrc
call :link_obsidian_config_file config
call :link_obsidian_config_file daily-notes.json
call :link_obsidian_config_file global-search.json
call :link_obsidian_config_file graph.json
call :link_obsidian_config_file publish.json
call :link_obsidian_config_dir themes
call :link_obsidian_config_dir snippets
call :link_obsidian_config_dir plugins

call :******************** IntelliJ IDEA

set IDEA_DIR=IntelliJIdea2021.1

set IDEA_ORIGIN_CONFIG_DIR=%COMMON_MNT%\IntelliJIdea\config
set IDEA_CONFIG_DIR=%ROAMING%\JetBrains\%IDEA_DIR%

call :link_idea_dir colors
call :link_idea_dir keymaps
call :link_idea_dir templates
call :link_idea_dir codestyles
call :link_idea_dir inspection
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

call :******************** PowerShell Core

set POWER_SHELL_ORIGIN_DIR=%WINDOWS_MNT%\power-shell
set POWER_SHELL_DIR=%USERPROFILE%\Documents\PowerShell

call :link_file "%USERPROFILE%\.oh-my-posh.json" %WINDOWS_MNT%\.oh-my-posh.json
call :link_file %POWER_SHELL_DIR%\Microsoft.PowerShell_profile.ps1 %POWER_SHELL_ORIGIN_DIR%\Microsoft.PowerShell_profile.ps1


call :******************** Terminal

set TERMINAL_ORIGIN_DIR=%WINDOWS_MNT%\terminal
call :link_file "%LOCAL%\Microsoft\Windows Terminal\settings.json" %TERMINAL_ORIGIN_DIR%\LocalState\settings.json

call :******************** Keypirinha

set KEYPIRINHA_ORIGIN_DIR=%WINDOWS_MNT%\keypirinha
call :link_file %SCOOP%\persist\keypirinha\portable\Profile\User\Keypirinha.ini %KEYPIRINHA_ORIGIN_DIR%\User\Keypirinha.ini

call :******************** Broot

call :link_file "%USERPROFILE%\broot.toml" %WINDOWS_MNT%\broot.toml


call :******************** git config

git config --global core.preloadindex true
git config --global core.fscache true
git config --global core.autoCRLF false
git config --global merge.ff false
git config --global pull.ff only
rem 日本語パスの文字化け防止対策
git config --global core.quotepath false


call :******************** To be continued.. (Not administrator

echo Install Tablacus Explorer manually!
echo Clone...
echo   * spinal-reflex-bindings-template
echo Create a shortcut of Xlaunch in `Star Menu / Program` with a to-link as following.
echo   * ex: C:\Users\syoum\scoop\apps\vcxsrv\current\xlaunch.exe -run C:\Users\syoum\git\github.com\tadashi-aikawa\owl-playbook\windows\ubuntu\config.xlaunch

goto :end
rem ---------------------------------------------------------

:link_windows_home
call :link_file %USERPROFILE%\%1 %WINDOWS_MNT%\%1
exit /b

:link_obsidian_file
call :link_file %OBSIDIAN_DIR%\%1 %OBSIDIAN_ORIGIN_DIR%\%1
exit /b

:link_obsidian_config_file
call :link_file %OBSIDIAN_CONFIG_DIR%\%1 %OBSIDIAN_ORIGIN_DIR%\%1
exit /b

:link_obsidian_config_dir
call :link_dir %OBSIDIAN_CONFIG_DIR%\%1 %OBSIDIAN_ORIGIN_DIR%\%1
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
