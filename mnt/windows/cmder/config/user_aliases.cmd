;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here


e.=explorer .
web="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" $*
te="C:\tablacus\TE64.exe" $*
cat="C:\tools\cmder\vendor\git-for-windows\usr\bin\cat.exe" $*
history=cat "C:\tools\Cmder\config\.history" $*


ls=ls --show-control-chars -F --color $*
pwd=cd
clear=cls
unalias=alias /d $1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"
ll=ls -l $*
cd~=cd "%HOME%"
rg=rg -L $*


gs=git status --short $*
gsv=git status -v $*
gd=git diff $*
gf=git fetch $*
gl=git log $*
gll=git log --oneline --all --graph --decorate $*
gls=git log -3 $*
glll=git log --graph --all --date=format:"%Y-%m-%d %H:%M" --pretty=format:"%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b"
glls=git log --graph --all --date=format:"%Y-%m-%d %H:%M" --pretty=format:"%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b" -10
gcv=git commit -v $*
gcm=git commit -m $*
ga=git add $*
gaa=git add --all $*


~1=~0,-1
