#!/bin/bash

usage_exit() {
  echo "Usage: $(basename "$0") -r <REQUIRED> [-o <OPTIONAL>] [-f]" 1>&2
    exit 1
}

post_slack() {
  local channel=$1
  local user=$2
  local emoji=$3
  local message=$4
  # good / danger
  local color=$5
  curl -X POST --data-urlencode 'payload={"link_names": 1, "channel": "'"${channel}"'", "username": "'"${user}"'", "icon_emoji": "'":${emoji}:"'", "attachments": [{"color": "'"${color}"'", "text": "'"${message}"'"}]}' ${SLACK_WEBHOOK_URL}
}

while getopts r:o:fh opt
do
    case $opt in
        r) REQUIRED=$OPTARG
            ;;
        o) OPTIONAL=$OPTARG
            ;;
        f) OPTIONAL_FLAG=1
            ;;
        *) usage_exit
            ;;
    esac
done

[[ -z "$REQUIRED" ]] && usage_exit

