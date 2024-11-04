# ----------------------------------------------------------
# あえて直接インストールモノ (パス関係などでトラブルを起こしやすいので)
# ----------------------------------------------------------
#  - VSCode
#  - Flow Launcher
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
  broot `
  busybox `
  clink `
  delta `
  dust `
  fd `
  ffmpeg `
  fzf `
  git `
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

# Python
scoop install python
