#!/bin/bash
# ISS Art bash template v.1.3
# set -o xtrace # turn on debugging
# dd="echo ---" # turn on displaying debug output
set -uo pipefail #e
[ -e "$(dirname "${0}")/isslib.sh" ] && . "$(dirname "${0}")/isslib.sh" || . isslib.sh
#---=== Variables section ===---
#VAR='val' # description
#---=== x ===---
#${dd} : "debug output string"

if [ -z "${1}" ]; then
  exitMsg "Usage: ${0} remote_name remote_url"
fi

msg "Push to ${1}"
set -o xtrace
git remote add ${1} ${2}
git push --force ${1} "master"
git push --force --prune ${1} --all
git push --force --prune ${1} --tags
git push --force --prune ${1} refs/notes/*
