#!/bin/zsh

#--------------------------------------
# コマンド履歴
#--------------------------------------
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
# 重複する古い履歴は削除
setopt histignorealldups
# セッションを跨いで履歴を共有
setopt sharehistory

#--------------------------------------
# 補完
#--------------------------------------
autoload -Uz compinit
compinit

# 高度な補完
zstyle ':completion:*' completer _expand _complete _correct _approximate
# 大文字小文字や各種記号をfuzzyに考慮して補完
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# ドットファイルを.はじまりでなくても補完
setopt globdots
# TABを候補の選択ではなくインタラクティブな絞り込みとして使う
zstyle ':completion:*' menu select interactive
setopt menu_complete
# 候補を ls -l のリストで表示
zstyle ':completion:*' file-list all
# cdの補完で自分自身を表示しない
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# 補完候補のディレクトリには色をつける
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
autoload colors && colors

# OSC 133 sequences
preexec() { printf "\033]133;A\033\\" }
precmd()  { printf "\033]133;B\033\\" }

# ESC単独の無効化
function ignore_esc() { true }
zle -N ignore_esc
bindkey '\e' ignore_esc

# ESC 1回押しのあとにアルファベットが入力されたらプロンプトに入力する
for char in {a..z}; do
  bindkey -r "\e$char"
done

# ESC+jでNeovimを起動
function run_vim() {
  LBUFFER="vim"
  zle accept-line
}
zle -N run_vim
bindkey '\ej' run_vim

