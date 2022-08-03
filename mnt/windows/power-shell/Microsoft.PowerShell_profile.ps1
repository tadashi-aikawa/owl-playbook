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

# 予測インテリセンス
Set-PSReadLineOption -PredictionSource History

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

oh-my-posh init pwsh --config ~/.oh-my-posh.json | Invoke-Expression

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

# https://secon.dev/entry/2020/08/17/070735/
@"
  arch, base32, base64, basename, cat, cksum, comm, cp, cut, date, df, dircolors, dirname,
  echo, env, expand, expr, factor, false, fmt, fold, hashsum, head, hostname, join, link, ln,
  ls, md5sum, mkdir, mktemp, more, mv, nl, nproc, od, paste, printenv, printf, ptx, pwd,
  readlink, realpath, relpath, rm, rmdir, seq, sha1sum, sha224sum, sha256sum, sha3-224sum,
  sha3-256sum, sha3-384sum, sha3-512sum, sha384sum, sha3sum, sha512sum, shake128sum,
  shake256sum, shred, shuf, sleep, sort, split, sum, sync, tac, tail, tee, test, touch, tr,
  true, truncate, tsort, unexpand, uniq, wc, whoami, yes
"@ -split ',' |
ForEach-Object { $_.trim() } |
Where-Object { ! @('tee', 'sort', 'sleep').Contains($_) } |
ForEach-Object {
    $cmd = $_
    if (Test-Path Alias:$cmd) { Remove-Item -Path Alias:$cmd }
    $fn = '$input | uutils ' + $cmd + ' $args'
    Invoke-Expression "function global:$cmd { $fn }"
}

# ⚠ readonlyのaliasなので問題が発生するかも..
Remove-Item alias:sort -Force
function sort() { $input | uutils sort $args}

# 代替コマンドを使用
Set-Alias grep rg
function ls() { uutils ls $args }
function tree() { exa --icons -T $args}

# Linuxコマンドのエイリアス
function ll() { exa --icons -l --git $args}

function awslocal { aws '--endpoint-url=http://localhost:4566' $args }

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
function ffjpeg() { ffmpeg -i $args[0] -vf scale=1280":-1" $args[0] }

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

# owl
function owl() {
  cp $env:USERPROFILE/git/github.com/tadashi-aikawa/owl-playbook/task/Taskfile_windows.yml Taskfile_tmp.yml
  task -t Taskfile_tmp.yml $args
  rm Taskfile_tmp.yml
}

#-----------------------------------------------------
# Java (IDEA用)
#-----------------------------------------------------

$env:JAVA_HOME = $env:LOCALAPPDATA + "\JetBrains\Toolbox\apps\IDEA-U\ch-0\222.3345.118\jbr"

#-----------------------------------------------------
# Golang
#-----------------------------------------------------

$env:GO111MODULE = "on"

#-----------------------------------------------------
# Execution PATHs
#-----------------------------------------------------

$env:PATH += ";" + $env:LOCALAPPDATA + "\JetBrains\Toolbox\apps\IDEA-U\ch-0\222.3345.118\bin"
$env:PATH += ";" + $env:USERPROFILE + "\git\bitbucket.org\ntj-developer\diamant\target\release"


$scriptBlock = {
	param($commandName, $wordToComplete, $cursorPosition)
	$curReg = "task{.exe}? (.*?)$"
	$startsWith = $wordToComplete | Select-String $curReg -AllMatches | ForEach-Object { $_.Matches.Groups[1].Value }
	$reg = "\* ($startsWith.+?):"
	$listOutput = $(task -l)
	$listOutput | Select-String $reg -AllMatches | ForEach-Object { $_.Matches.Groups[1].Value + " " }
}

Register-ArgumentCompleter -Native -CommandName task -ScriptBlock $scriptBlock

