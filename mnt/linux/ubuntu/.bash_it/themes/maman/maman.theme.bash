#!/usr/bin/env bash

# Use in scm_prompt_vars
SCM_GIT_STAGED_CHAR=" "
SCM_GIT_UNSTAGED_CHAR=" "
SCM_GIT_UNTRACKED_CHAR=" "
SCM_GIT_AHEAD_CHAR=" "
SCM_GIT_BEHIND_CHAR=" "
SCM_THEME_TAG_PREFIX=" "
SCM_THEME_PROMPT_CLEAN=""
SCM_THEME_PROMPT_DIRTY=""

# Separator instead of /
SEP=""

##################################################
#
# | prompt > virtual_env > scm > cwd > status >
#
##################################################
PROMPT_THEME_BG=2

# Python virtualenv
VIRTUAL_ENV_FG=255
VIRTUAL_ENV_BG=4

VIRTUAL_ENV_SYMBOL=" "

# Source code management
SCM_CLEAN_FG=231
SCM_DIRTY_FG=196
SCM_STAGED_FG=220
SCM_UNSTAGED_FG=166
SCM_BEHIND_FG=2
SCM_AHEAD_FG=2

SCM_BG=16

SCM_NONE_CHAR=""
SCM_GIT_CHAR=" "
SCM_GIT_CHAR_REMOTE_DEFAULT=" "
SCM_GIT_CHAR_REMOTE_NO_DEFAULT=" "
SCM_GIT_CHAR_GITHUB=" "
SCM_GIT_CHAR_BITBUCKET=" "

# Current working directory
CWD_FG=159
CWD_BG=236

# Status
STATUS_FG=1
STATUS_BG=52

#######################################
# Arguments:
#   None
# Returns:
#   None
# Stdout:
#   Logo emoji (ex: )
#######################################
function git_remote_logo() {
  if [[ "$(_git-upstream)" == "" ]]; then
    echo "$SCM_GIT_CHAR_REMOTE_NO_DEFAULT"
    return
  fi

  local remote_domain
  remote_domain=$(git remote get-url origin | awk -F'[@:.]' '{print $2}')
  case ${remote_domain//\//} in
    github) echo "$SCM_GIT_CHAR_GITHUB" ;;
    bitbucket) echo "$SCM_GIT_CHAR_BITBUCKET" ;;
    *) echo "$SCM_GIT_CHAR_REMOTE_DEFAULT" ;;
  esac
}

##############################################
# Arguments:
#   None
# Returns:
#   None
# Stdout:
#   Short current work directory (ex: ~/hoge)
##############################################
function short_cwd() {
  echo "$(pwd) " |
    sed -r "s@${HOME}/git/github.com@${SCM_GIT_CHAR_GITHUB}@g" |
    sed -r "s@${HOME}@~@g" |
    sed -r "s/\//  /2g"
}

##############################################
# Arguments:
#   $1: Background color of separator
# Stdout:
#   Separator
##############################################
function separator() {
  echo "$(bg "${1}")${SEP}"
}

##############################################
# Arguments:
#   $1: foreground color (ex: 208)
# Returns:
#   None
# Stdout:
#   Color string
##############################################
function fg() {
  echo -e "\[\033[38;5;${1}m\]"
}

##############################################
# Arguments:
#   $1: background color (ex: 208)
# Returns:
#   None
# Stdout:
#   Color string
##############################################
function bg() {
  echo -e "\[\033[48;5;${1}m\]"
}

##############################################
# Arguments:
#   $1: foreground color (ex: 208)
#   $2: background color (ex: 208)
# Returns:
#   None
# Stdout:
#   Color string
##############################################
function fgbg() {
  echo -e "\[\033[38;5;${1};48;5;${2}m\]"
}

##############################################
# (1)
##############################################
function build_shell_prompt() {
  echo "$(bg ${PROMPT_THEME_BG}) $(fg ${PROMPT_THEME_BG})"
}

##############################################
# (2)
##############################################
function build_virtualenv_prompt() {
  local environ=""

  if [[ -n "$VIRTUAL_ENV" ]]; then
    environ=$(basename "$VIRTUAL_ENV")
  fi

  if [[ -n "$environ" ]]; then
    echo "$(separator ${VIRTUAL_ENV_BG}) $(fgbg ${VIRTUAL_ENV_FG} ${VIRTUAL_ENV_BG})${VIRTUAL_ENV_SYMBOL}$environ $(fg ${VIRTUAL_ENV_BG})"
  fi
}

##############################################
# (3)
##############################################
function build_scm_prompt() {
  scm_prompt_vars

  if [[ "${SCM_NONE_CHAR}" == "${SCM_CHAR}" ]]; then
    return
  fi
  if [[ "${SCM_GIT_CHAR}" != "${SCM_CHAR}" ]]; then
    return
  fi

  local fg_local
  if [[ "${SCM_DIRTY}" -eq 3 ]]; then
    fg_local=${SCM_STAGED_FG}
  elif [[ "${SCM_DIRTY}" -eq 2 ]]; then
    fg_local=${SCM_UNSTAGED_FG}
  elif [[ "${SCM_DIRTY}" -eq 1 ]]; then
    fg_local=${SCM_DIRTY_FG}
  else
    fg_local=${SCM_CLEAN_FG}
  fi

  ahead=$(sed -nr "s@.*( ${SCM_GIT_AHEAD_CHAR}[0-9]+).*@\\1@pg" <<<${SCM_BRANCH})
  behind=$(sed -nr "s@.*( ${SCM_GIT_BEHIND_CHAR}[0-9]+).*@\\1@pg" <<<${SCM_BRANCH})
  without_remote=$(
    sed -r "s@(.*)( ${SCM_GIT_BEHIND_CHAR}[0-9]+)(.*)@\\1\\3@g" <<<${SCM_BRANCH} |
      sed -r "s@(.*)( ${SCM_GIT_AHEAD_CHAR}[0-9]+)(.*)@\\1\\3@g"
  )

  local fg_behind=${SCM_CLEAN_FG}
  if [[ ${behind} != "" ]]; then
    fg_behind=${SCM_BEHIND_FG}
  fi

  local fg_ahead=${SCM_CLEAN_FG}
  if [[ ${ahead} != "" ]]; then
    fg_ahead=${SCM_AHEAD_FG}
  fi

  SCM_PREFIX="$(fgbg ${fg_behind} ${SCM_BG})$(git_remote_logo)${behind} $(fg 0)$(fg ${fg_ahead})${ahead} $(fgbg ${fg_local} ${SCM_BG})${SCM_CHAR}${without_remote}${SCM_STATE}"
  echo "$(separator ${SCM_BG}) ${bold_white}${SCM_PREFIX} $(fg ${SCM_BG})"
}

##############################################
# (4)
##############################################
function build_cwd_prompt() {
  echo "$(separator ${CWD_BG}) $(fgbg ${CWD_FG} ${CWD_BG})$(short_cwd)$(fg ${CWD_BG})"
}

##############################################
# (5)
# Arguments:
#   $1: last_status_code (ex: 127)
##############################################
function build_status_prompt() {
  if [[ "$1" -ne 0 ]]; then
    echo "$(separator ${STATUS_BG}) $(fgbg ${STATUS_FG} ${STATUS_BG})${1} $(fg ${STATUS_BG})"
  fi
}

##############################################
# Last
##############################################
function tail() {
  echo "$(separator 0)${normal} "
}

##############################################
# Main
##############################################
function main() {
  err_code="$?"
  PS1="$(build_shell_prompt)$(build_virtualenv_prompt)$(build_scm_prompt)$(build_cwd_prompt)$(build_status_prompt $err_code)$(tail)"
}

PROMPT_COMMAND=main
