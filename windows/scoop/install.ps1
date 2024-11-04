# ----------------------------------------------------------
# あえて直接インストールモノ (パス関係などでトラブルを起こしやすいので)
# ----------------------------------------------------------
#  - VSCode
#  - Flow Launcher (今ならいける??)
#  - AutoHotkey

# Add versions bucket
scoop bucket add versions
# Add extras
scoop bucket add extras

# CLI Tools
# lessはbatなどで必要
scoop install `
  7zip `
  bat `
  bind `
  bottom `
  broot `
  busybox `
  clink `
  delta `
  doggo `
  dust `
  eza `
  fd `
  ffmpeg `
  fzf `
  git `
  imhex `
  jid `
  jq `
  less `
  make `
  neovim `
  ripgrep `
  sudo `
  starship `
  task `
  uutils-coreutils `
  vim `
  watchexec `
  xh `
  zoxide

# GUI Tools
scoop install `
  bruno `
  dbeaver `
  ditto `
  gimp `
  windows-terminal `
  winmerge

# gcc
scoop install gcc
# Python
scoop install python
