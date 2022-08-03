# Add versions bucket
scoop bucket add versions
# Add extras
scoop bucket add extras

# CLI Tools
# lessはbatなどで必要
scoop install `
  busybox `
  less `
  sudo `
  bat `
  bind `
  fd `
  dust `
  7zip `
  fzf `
  jq `
  jid `
  ripgrep `
  delta `
  lsd `
  make `
  ffmpeg `
  vim `
  neovim `
  uutils-coreutils `
  broot `
  xh `
  zoxide `
  task `
  git `
  watchexec `
  oh-my-posh

# GUI Tools
scoop install `
  windows-terminal `
  dbeaver `
  postman `
  keypirinha `
  ditto `
  draw.io
# vscodeは直接インストール

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
  python
scoop reset python

sudo scoop install autohotkey-installer
# In the future..: scoop install volta
#
