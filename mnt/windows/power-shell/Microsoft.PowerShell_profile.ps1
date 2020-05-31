#-----------------------------------------------------
# General
#-----------------------------------------------------

# PowerShell Core7でもConsoleのデフォルトエンコーディングはsjisなので必要
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[System.Console]::InputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")

# git logなどのマルチバイト文字を表示させるため (絵文字含む)
$env:LESSCHARSET = "utf-8"

# 音を消す
Set-PSReadlineOption -BellStyle None

#-----------------------------------------------------
# Key binding
#-----------------------------------------------------

# Emacsベース
Set-PSReadLineOption -EditMode Emacs

#-----------------------------------------------------
# Powerline
#-----------------------------------------------------

Import-Module posh-git
Import-Module oh-my-posh
Import-Module z

Set-Theme Powerlevel10k-Lean

# Prompt
$ThemeSettings.Colors.DriveForegroundColor = "Blue"
# Git
$ThemeSettings.GitSymbols.LocalStagedStatusSymbol = ""
$ThemeSettings.GitSymbols.LocalWorkingStatusSymbol = ""
$ThemeSettings.GitSymbols.BeforeWorkingSymbol = [char]::ConvertFromUtf32(0xf040)+" "
$ThemeSettings.GitSymbols.DelimSymbol = [char]::ConvertFromUtf32(0xf040)
$ThemeSettings.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0xf126)
$ThemeSettings.GitSymbols.BranchAheadStatusSymbol = [char]::ConvertFromUtf32(0xf0ee)+" "
$ThemeSettings.GitSymbols.BranchBehindStatusSymbol = [char]::ConvertFromUtf32(0xf0ed)+" "
$ThemeSettings.GitSymbols.BeforeIndexSymbol = [char]::ConvertFromUtf32(0xf6b7)+" "
$ThemeSettings.GitSymbols.BranchIdenticalStatusToSymbol = ""
$ThemeSettings.GitSymbols.BranchUntrackedSymbol = [char]::ConvertFromUtf32(0xf663)+" "

#-----------------------------------------------------
# fzf
#-----------------------------------------------------

# fzf
$env:FZF_DEFAULT_OPTS="--reverse --border --height 50%"
$env:FZF_DEFAULT_COMMAND='fd -HL --exclude ".git" .'
function _fzf_compgen_path() {
    fd -HL --exclude ".git" . "$1"
}
function _fzf_compgen_dir() {
    fd --type d -HL --exclude ".git" . "$1"
}

#-----------------------------------------------------
# Linux like commands
#-----------------------------------------------------

# パイプラインを受けつけないLinux標準コマンド
Remove-Item alias:cp
function cp() { uutils cp $args}
Remove-Item alias:mv
function mv() { uutils mv $args}
Remove-Item alias:rm
function rm() { uutils rm $args}
Remove-Item alias:ls
function mkdir() { uutils mkdir $args}
function printenv() { uutils printenv $args}

# パイプラインを受けつけるLinux標準コマンド
Remove-Item alias:cat
function cat() { $input | uutils cat $args}
function head() { $input | uutils head $args}
function tail() { $input | uutils tail $args}
function wc() { $input | uutils wc $args}
function tr() { $input | uutils tr $args}
function pwd() { $input | uutils pwd $args}
function cut() { $input | uutils cut $args}
function uniq() { $input | uutils uniq $args}
# ⚠ readonlyのaliasなので問題が発生するかも..
Remove-Item alias:sort -Force
function sort() { $input | uutils sort $args}

# 代替コマンドを使用
Set-Alias grep rg
function ls() { exa --icons $args }
function tree() { exa --icons -T $args}

# Linuxコマンドのエイリアス
function ll() { uutils ls -l $args}

#-----------------------------------------------------
# Useful commands
#-----------------------------------------------------

# cd
function cdg() { gowl list | fzf | cd }
function cdr() { fd -H -t d -E .git -E node_modules | fzf | cd }
function cdz() { z -l | oss | select -skip 3 | % { $_ -split " +" } | sls -raw '^[a-zA-Z].+' | fzf | cd }

# vim
function vimr() { fd -H -E .git -E node_modules | fzf | % { vim $_ } }

# Copy current path
function cpwd() { Convert-Path . | Set-Clipboard }

# git flow
function gf()  { git fetch --all }
function gd()  { git diff $args }
function ga()  { git add $args }
function gaa() { git add --all }
function gco() { git commit -m $args[0] }

# git switch
function gb()  { git branch -l | rg -v '^\* ' | % { $_ -replace " ", "" } | fzf | % { git switch $_ } }
function gbr() { git branch -rl | rg -v "HEAD|master" | % { $_ -replace "  origin/", "" } | fzf | % { git switch $_ } }
function gbc() { git switch -c $args[0] }
function gbm()  { git branch -l | rg -v '^\* ' | % { $_ -replace " ", "" } | fzf | % { git merge --no-ff $_ } }

# git log
function gls()   { git log -3}
function gll()   { git log -10 --oneline --all --graph --decorate }
function glll()  { git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset\ %C(yellow)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' }
function glls()  { git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset\ %C(yellow)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' -10}

# git status
function gs()  { git status --short }
function gss() { git status -v }
