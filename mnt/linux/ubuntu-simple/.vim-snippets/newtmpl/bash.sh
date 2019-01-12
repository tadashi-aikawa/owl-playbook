#!/bin/bash

usage_exit() {
  echo "Usage: $(basename "$0") -r <REQUIRED> [-o <OPTIONAL>] [-f]" 1>&2
    exit 1
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

