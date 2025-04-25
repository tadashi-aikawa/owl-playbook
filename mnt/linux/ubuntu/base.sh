export PATH=${PATH}:~/bin

# INFO: wl-copy を動かすため https://zenn.dev/junkor/articles/cf64671f4fc637
# もし$XDG_RUNTIME_DIR/wayland-0 が存在しなかったら、/mnt/wslg/runtime_dir/wayland-0のシンボリックリンクを貼る
if [ ! -S "$XDG_RUNTIME_DIR/wayland-0" ]; then
  # wayland-0に加えて、wayland-0.lockというファイルもあるのでまとめてシンボリックリンクを貼る(※無くても一応動いた)
  ln -s /mnt/wslg/runtime-dir/wayland-0* "$XDG_RUNTIME_DIR"
fi

alias i="cd"
alias s="bat"
alias e="/mnt/c/Windows/explorer.exe"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias gf="git fetch --all"
alias ga='git add'
alias gaa='git add --all'
alias gb='git checkout $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gbc='git checkout -b'
alias gco='git commit -m'
alias gbr='git branch -rl | grep -vE "HEAD|master" | tr -d " " | sed -r "s@origin/@@g" | fzf | xargs -i git checkout -b {} origin/{}'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --all'
alias gl='git log'
gbdl() {
  git fetch -p && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D
}

alias gls='git-graph -n 30 -s round'
alias gll='git-graph -n 5 -s round --format "%h %d %s%n 💿%ad 👤<%ae>%n%n"'
alias glll='git-graph -s round --format "%h %d %s%n 💿%ad 👤<%ae>%n%n"'
alias glls="git log --graph --all --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(auto)%d%Creset %C(yellow reverse)%h%Creset %C(magenta)%ae%Creset %C(cyan)%ad%Creset%n%C(white bold)%w(80)%s%Creset%n%b' -10"
alias gbm='git merge --no-ff $(git branch -l | grep -vE "^\*" | tr -d " " | fzf)'
alias gs='git status --short'
alias gss='git status -v'

alias gpf="git push --force-with-lease --force-if-includes origin HEAD"

alias show='bat --pager never'

alias cdg='cd $(gowl list | fzf)'

alias lg='lazygit'
alias ld='lazydocker'
alias lq='lazysql'

alias cpwd='pwd | xsel -bi'

# shellcheck disable=SC2154
alias zvim='dst=$(nvim --headless -c "lua for _, f in ipairs(vim.tbl_filter(function(file) return vim.fn.filereadable(file) == 1 end, vim.v.oldfiles)) do io.stdout:write(f .. \"\n\") end" -c "qa" | fzf --no-sort) && [[ -n $dst ]] && nvim $dst'

function v() {
  if [ -n "$VIRTUAL_ENV" ]; then
    deactivate
    echo "⏹️ Deactivated previous virtual environment: $(basename "$VIRTUAL_ENV")"
    return 0
  fi

  if [ -d ".venv" ]; then
    # shellcheck disable=SC1091
    source .venv/bin/activate
    echo "🔌 Activated .venv virtual environment"
  elif [ -d "venv" ]; then
    # shellcheck disable=SC1091
    source venv/bin/activate
    echo "🔌 Activated venv virtual environment"
  else
    echo "Error: No virtual environment (.venv or venv) found in current directory" >&2
    return 1
  fi
}
