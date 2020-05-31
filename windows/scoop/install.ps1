# Add versions bucket
scoop bucket add versions
# Add extras
scoop bucket add extras

# CLI Tools
scoop install `
  sudo `
  wget `
  bat `
  fd `
  7zip `
  fzf `
  jq `
  fx `
  less `
  ripgrep `
  make `
  ffmpeg `
  z `
  vim

# GUI Tools
scoop install `
  windows-terminal
  # slack
  # powertoys / dotnet-sdk

# Language / Framework / MiddleWare
scoop install `
  nodejs-lts `
  docker `
  go `
  hugo-extended

# Python
scoop install `
  python27 `
  python37 `
  python
scoop reset python

sudo scoop install autohotkey-installer
