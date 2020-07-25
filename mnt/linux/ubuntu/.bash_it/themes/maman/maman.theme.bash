#!/usr/bin/env bash
# Inspired Power-Turk theme for bash-it
# Author of Power-Turk (C) 2015 Ahmed Seref Guneysu

THEME_PROMPT_SEPARATOR=""

SHELL_SSH_CHAR=" "
SHELL_THEME_PROMPT_COLOR=2
SHELL_SSH_THEME_PROMPT_COLOR=208

VIRTUALENV_CHAR="ⓔ "
VIRTUALENV_THEME_PROMPT_COLOR=35

SCM_NONE_CHAR=""

SCM_GIT_CHAR=" " # " "
SCM_GIT_CHAR_REMOTE_DEFAULT=" "
SCM_GIT_CHAR_REMOTE_NO_DEFAULT=" "
SCM_GIT_CHAR_GITHUB=" "
SCM_GIT_CHAR_BITBUCKET=" "
SCM_GIT_STAGED_CHAR=" "
SCM_GIT_UNSTAGED_CHAR=" "
SCM_GIT_UNTRACKED_CHAR=" "
SCM_GIT_AHEAD_CHAR=" "
SCM_GIT_BEHIND_CHAR=" "
SCM_THEME_TAG_PREFIX=" "

SCM_THEME_PROMPT_CLEAN=""
SCM_THEME_PROMPT_DIRTY=""

SCM_THEME_PROMPT_COLOR=16
SCM_THEME_PROMPT_CLEAN_COLOR=231
SCM_THEME_PROMPT_DIRTY_COLOR=196
SCM_THEME_PROMPT_STAGED_COLOR=220
SCM_THEME_PROMPT_UNSTAGED_COLOR=166

CWD_THEME_PROMPT_COLOR=236 #240
CWD_THEME_PROMPT_CHAR_COLOR=159

LAST_STATUS_THEME_PROMPT_COLOR=52


function _git-uptream-remote-logo {
    if [[ "$(_git-upstream)" == "" ]]; then
      SCM_GIT_CHAR_REMOTE="$SCM_GIT_CHAR_REMOTE_NO_DEFAULT"
      return
    fi

    local remote_domain
    remote_domain=$(git remote get-url origin | awk -F'[@:.]' '{print $2}')
    case ${remote_domain//\//} in
        github ) SCM_GIT_CHAR_REMOTE="$SCM_GIT_CHAR_GITHUB";;
        bitbucket ) SCM_GIT_CHAR_REMOTE="$SCM_GIT_CHAR_BITBUCKET";;
        * ) SCM_GIT_CHAR_REMOTE="$SCM_GIT_CHAR_REMOTE_DEFAULT";;
    esac
}

_swd(){
# Adapted from http://stackoverflow.com/a/2951707/1766716
    begin="" # The unshortened beginning of the path.
    shortbegin="" # The shortened beginning of the path.
    current="" # The section of the path we're currently working on.
    end="${2:-$(pwd)}/" # The unmodified rest of the path.

    if [[ "$end" =~ "$HOME" ]]; then
        INHOME=1
        end="${end#$HOME}" #strip /home/username from start of string
        begin="$HOME"      #start expansion from the right spot
    else
        INHOME=0
    fi

    end="${end#/}" # Strip the first /
    shortenedpath="$end" # The whole path, to check the length.
    maxlength="${1:-0}"

    shopt -q nullglob && NGV="-s" || NGV="-u" # Store the value for later.
    shopt -s nullglob    # Without this, anything that doesn't exist in the filesystem turns into */*/*/...

    while [[ "$end" ]] && (( ${#shortenedpath} > maxlength ))
    do
        current="${end%%/*}" # everything before the first /
        end="${end#*/}"    # everything after the first /

        #advance
        begin="$begin/$current"
        shortbegin="$shortbegin/$current"
        shortenedpath="$shortbegin/$end"
    done

    shortenedpath="${shortenedpath%/}" # strip trailing /
    shortenedpath="${shortenedpath#/}" # strip leading /

    # Replaces slashes with  except first occurence.
    if [ $INHOME -eq 1 ]; then
        echo "~/$shortenedpath " | sed "s/\//  /2g" # make sure it starts with ~/
    else
        echo "/$shortenedpath "  | sed "s/\//  /2g" # Make sure it starts with /
    fi

    shopt "$NGV" nullglob # Reset nullglob in case this is being used as a function.

}
function set_rgb_color {
    if [[ "${1}" != "-" ]]; then
        fg="38;5;${1}"
    fi
    if [[ "${2}" != "-" ]]; then
        bg="48;5;${2}"
        [[ -n "${fg}" ]] && bg=";${bg}"
    fi
    echo -e "\[\033[${fg}${bg}m\]"
}

function powerline_shell_prompt {
    if [[ -n "${SSH_CLIENT}" ]]; then
        SHELL_PROMPT="${bold_white}$(set_rgb_color - ${SHELL_SSH_THEME_PROMPT_COLOR}) ${SHELL_SSH_CHAR}\u@\h ${normal}"
        LAST_THEME_COLOR=${SHELL_SSH_THEME_PROMPT_COLOR}
    else
        SHELL_PROMPT="${bold_white}$(set_rgb_color - ${SHELL_THEME_PROMPT_COLOR}) ${normal}"
        LAST_THEME_COLOR=${SHELL_THEME_PROMPT_COLOR}
    fi
}

function powerline_virtualenv_prompt {
    local environ=""

    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        environ="conda: $CONDA_DEFAULT_ENV"
    elif [[ -n "$VIRTUAL_ENV" ]]; then
        environ=$(basename "$VIRTUAL_ENV")
    fi

    if [[ -n "$environ" ]]; then
        VIRTUALENV_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${VIRTUALENV_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}${normal}$(set_rgb_color - ${VIRTUALENV_THEME_PROMPT_COLOR}) ${VIRTUALENV_CHAR}$environ ${normal}"
        LAST_THEME_COLOR=${VIRTUALENV_THEME_PROMPT_COLOR}
    else
        VIRTUALENV_PROMPT=""
    fi
}

function powerline_scm_prompt {
    scm_prompt_vars

    if [[ "${SCM_NONE_CHAR}" != "${SCM_CHAR}" ]]; then
        _git-uptream-remote-logo 

        if [[ "${SCM_DIRTY}" -eq 3 ]]; then
            SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_STAGED_COLOR} ${SCM_THEME_PROMPT_COLOR})"
        elif [[ "${SCM_DIRTY}" -eq 2 ]]; then
            SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_UNSTAGED_COLOR} ${SCM_THEME_PROMPT_COLOR})"
        elif [[ "${SCM_DIRTY}" -eq 1 ]]; then
            SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_DIRTY_COLOR} ${SCM_THEME_PROMPT_COLOR})"
        else
            SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_CLEAN_COLOR} ${SCM_THEME_PROMPT_COLOR})"
        fi
        if [[ "${SCM_GIT_CHAR}" == "${SCM_CHAR}" ]]; then
            SCM_PROMPT+=" ${SCM_GIT_CHAR_REMOTE} ${SCM_CHAR}${SCM_BRANCH}${SCM_STATE}"
        fi
        
        SCM_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${SCM_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}${normal}${SCM_PROMPT} ${normal}"
        LAST_THEME_COLOR=${SCM_THEME_PROMPT_COLOR}
    else
        SCM_PROMPT=""
    fi
}

function powerline_cwd_prompt {
CWD_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${CWD_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}$(set_rgb_color ${CWD_THEME_PROMPT_CHAR_COLOR} ${CWD_THEME_PROMPT_COLOR}) $(_swd)${normal}$(set_rgb_color ${CWD_THEME_PROMPT_COLOR} -)${normal}"
    LAST_THEME_COLOR=${CWD_THEME_PROMPT_COLOR}
}

function powerline_last_status_prompt {
    if [[ "$1" -eq 0 ]]; then
        LAST_STATUS_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} -)${THEME_PROMPT_SEPARATOR}${normal}"
    else
        LAST_STATUS_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${LAST_STATUS_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}${normal}$(set_rgb_color - ${LAST_STATUS_THEME_PROMPT_COLOR}) ${LAST_STATUS} ${normal}$(set_rgb_color ${LAST_STATUS_THEME_PROMPT_COLOR} -)${THEME_PROMPT_SEPARATOR}${normal}"
    fi
}

function powerline_prompt_command() {
    local LAST_STATUS="$?"

    powerline_shell_prompt
    powerline_virtualenv_prompt
    powerline_scm_prompt
    powerline_cwd_prompt
    powerline_last_status_prompt LAST_STATUS

    PS1="${SHELL_PROMPT}${VIRTUALENV_PROMPT}${SCM_PROMPT}${CWD_PROMPT}${LAST_STATUS_PROMPT} "
}

PROMPT_COMMAND=powerline_prompt_command

