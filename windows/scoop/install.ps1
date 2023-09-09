# ----------------------------------------------------------
# あえて直接インストールモノ (パス関係などでトラブルを起こしやすいので)
# ----------------------------------------------------------
#  - IntelliJ IDEA
#  - VSCode
#  - Flow Launcher
#  - AutoHotkey

# Add versions bucket
scoop bucket add versions
# Add extras
scoop bucket add extras
# Add Java
scoop bucket add java

# CLI Tools
# lessはbatなどで必要
scoop install `
  7zip `
  bat `
  bind `
  broot `
  busybox `
  delta `
  dust `
  fd `
  ffmpeg `
  fzf `
  git `
  gitui `
  jid `
  jq `
  less `
  make `
  neovim `
  oh-my-posh `
  ripgrep `
  sudo `
  task `
  uutils-coreutils `
  vim `
  watchexec `
  xh `
  zoxide

# GUI Tools
scoop install `
  dbeaver `
  ditto `
  draw.io `
  gimp `
  postman `
  windows-terminal `
  winmerge

# Language / Framework / MiddleWare
scoop install `
  docker `
  go `
  rustup-msvc `
  hugo-extended `
  volta `
  vcxsrv

# Python
scoop install `
  python27 `
  python37 `
  python38 `
  python39 `
  python310 `
  python
scoop reset python
