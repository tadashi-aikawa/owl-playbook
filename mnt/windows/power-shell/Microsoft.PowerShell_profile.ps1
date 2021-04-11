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

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell) -join "`n"
})

Set-PoshPrompt -Theme  ~/.oh-my-posh.json

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
Remove-Item alias:pwd
function pwd() { $input | uutils pwd $args}
function cut() { $input | uutils cut $args}
function uniq() { $input | uutils uniq $args}
# ⚠ readonlyのaliasなので問題が発生するかも..
Remove-Item alias:sort -Force
function sort() { $input | uutils sort $args}

# 代替コマンドを使用
Set-Alias grep rg
function ls() { uutils ls $args }
function tree() { exa --icons -T $args}

# Linuxコマンドのエイリアス
function ll() { uutils ls -l $args}

#-----------------------------------------------------
# Useful commands
#-----------------------------------------------------

# cd
function ..() { cd ../ }
function ...() { cd ../../ }
function ....() { cd ../../../ }
function cdg() { gowl list | fzf | cd }
function cdr() { fd -H -t d -E .git -E node_modules | fzf | cd }
Set-Alias cdz zi
function buscdd() { ls -1 C:\\Work\\treng\\Bus\\data | rg .*$Arg1.*_xrf | fzf | % { cd C:\\Work\\treng\\Bus\\data\\$_ } }
function buscdw() { ls -1 C:\\Work\\treng\\Bus\\work | rg .*$Arg1.*_xrf | fzf | % { cd C:\\Work\\treng\\Bus\\work\\$_ } }

# vim
function vimr() { fd -H -E .git -E node_modules | fzf | % { vim $_ } }

# Copy current path
function cpwd() { Convert-Path . | Set-Clipboard }

# git flow
function gf()  { git fetch --all }
function gd()  { git diff $args }
function gds()  { git diff --staged $args }
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

# explorer
function e() { explorer $args }

# ffmpeg
function ffmp4red() { ffmpeg -i $args[0] -vcodec libx264 -crf 20 $args[1] }
function ff256() { ffmpeg -i $args[0] -filter_complex "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse" $args[1] }
function ffresize() { $width = $args[1]; ffmpeg -i $args[0] -vf scale=$width":-1" $args[2] }
function fffavicon() { $width = $args[1]; ffmpeg -i $args[0] -vf scale=$width":-1" favicon.ico }

# broot
function bo() { broot -g --conf $env:USERPROFILE\broot.toml $args }
function br() {
    $outcmd = new-temporaryfile
    bo --outcmd $outcmd $args
    if (!$?) {
        remove-item -force $outcmd
        return $lastexitcode
    }

    $command = get-content $outcmd
    if ($command) {
        # workaround - paths have some garbage at the start
        $command = $command.replace("\\?\", "", 1)
        invoke-expression $command
    }
    remove-item -force $outcmd
} 

#-----------------------------------------------------
# Golang
#-----------------------------------------------------

$env:GO111MODULE = "on"

#-----------------------------------------------------
# Execution PATHs
#-----------------------------------------------------

$env:PATH += ";" + $env:LOCALAPPDATA + "\JetBrains\Toolbox\apps\IDEA-U\ch-0\203.5981.155\bin"
