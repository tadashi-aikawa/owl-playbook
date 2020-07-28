# Add versions bucket
scoop bucket add versions
# Add extras
scoop bucket add extras
# Add JetBrains
scoop bucket jetbrains

# CLI Tools
scoop install `
  sudo `
  wget `
  bat `
  fd `
  dust `
  7zip `
  fzf `
  jq `
  fx `
  less `
  ripgrep `
  lsd `
  make `
  ffmpeg `
  z `
  vim `
  uutils-coreutils

# GUI Tools
scoop install `
  windows-terminal `
  dbeaver `
  postman `
  keypirinha `
  ditto `
  vscode
  # slack

# Language / Framework / MiddleWare
scoop install `
  nodejs-lts `
  gcc `
  docker `
  go `
  rustup `
  hugo-extended `
  vcxsrv

# Python
scoop install `
  python27 `
  python37 `
  python
scoop reset python

sudo scoop install autohotkey-installer
