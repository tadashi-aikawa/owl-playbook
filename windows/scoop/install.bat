rem Add versions bucket
call scoop bucket add versions
rem Add extras
call scoop bucket add extras

rem CLI Tools
call scoop install ^
  sudo ^
  wget ^
  bat ^
  fd ^
  7zip ^
  fzf ^
  jq ^
  less ^
  ripgrep ^
  make ^
  ffmpeg

rem Language / Framework / MiddleWare
call scoop install ^
  nodejs-lts ^
  docker ^
  go ^
  autohotkey ^
  hugo-extended

rem Python
call scoop install ^
  python27 ^
  python37 ^
  python
call scoop reset python

rem C Tools
rem scoop install ^
rem   llvm ^
rem   cmake
