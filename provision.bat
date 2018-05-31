@echo off


rem ------------------
rem Install
rem ------------------

cinst /y .\packages.config

rem ------------------
rem Sym links
rem ------------------

set MNT_DIR=%USERPROFILE%\Dropbox\ubuntu-mnt
set IDEA_ORIGIN_CONFIG_DIR=%MNT_DIR%\.IntelliJIdea\config

set IDEA_DIR=.IntelliJIdea2018.1
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
call :link_file %USERPROFILE%\.ideavimrc %MNT_DIR%\.ideavimrc

exit /b

rem ---------------------------------------------------------

:link_file
del %1
Mklink %1 %2
exit /b

:link_idea_file
del %IDEA_CONFIG_DIR%\%1
Mklink %IDEA_CONFIG_DIR%\%1 %IDEA_ORIGIN_CONFIG_DIR%\%1
exit /b

:link_idea_dir
rd /s /q %IDEA_CONFIG_DIR%\%1
Mklink /D %IDEA_CONFIG_DIR%\%1 %IDEA_ORIGIN_CONFIG_DIR%\%1
exit /b

