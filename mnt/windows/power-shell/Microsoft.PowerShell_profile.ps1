#-----------------------------------------------------
# Env
#-----------------------------------------------------

# パイプで渡したときに文字化けで処理が上手く行かない問題を回避するため
$utf8 = [System.Text.Encoding]::GetEncoding("utf-8")
$OutputEncoding = $utf8
[System.Console]::OutputEncoding = $utf8

# git logなどのマルチバイト文字を表示させるため (絵文字含む)
$env:LESSCHARSET = "utf-8"

#-----------------------------------------------------
# Powerline
#-----------------------------------------------------

Import-Module posh-git
Import-Module oh-my-posh
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
# Alias
#-----------------------------------------------------

# Git Bash配下のMinGW系コマンドが使えるなら使う
$linuxBin = "$HOME\scoop\apps\git\current\usr\bin"
$env:PATH += ";$linuxBin"

# Linux like (WSLの場合は日本語問題に遭遇しにくい。ただしpipeを使わない場合)
Remove-Item alias:cat
Remove-Item alias:rm
Remove-Item alias:curl
Remove-Item alias:wget

function ll() {
  if ($args -ne "") {
    Invoke-Expression "$linuxBin\ls -l $args"
  } else {
    Invoke-Expression "$linuxBin\ls -l"
  }
}

# cd
function cdg() { gowl list | fzf | cd }
function cdr() { fd -H -t d -E .git -E node_modules | fzf | cd }
function cdz() { z -l | oss | select -skip 3  | % { $_.Trim().Split(" *")[1] } | fzf | cd }

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
function gll()   { git log --oneline --all --graph --decorate }
function glll()  { git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset\ %C(yellow)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' }
function glls()  { git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset\ %C(yellow)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' -10}

# git status
function gs()  { git status --short }
function gss() { git status -v }
