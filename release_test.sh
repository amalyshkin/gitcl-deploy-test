#!/bin/bash
# ISS Art bash template v.1.3
# set -o xtrace # turn on debugging
# dd="echo ---" # turn on displaying debug output
set -euo pipefail
[ -e "$(dirname "${0}")/isslib.sh" ] && . "$(dirname "${0}")/isslib.sh" || . isslib.sh
#---=== Variables section ===---
regionNames=("n/a" "n/a" "us-east-1" "us-east-2" "eu-west-1-ireland" "eu-central-1-frankfurt" "ap-southeast-2-sydney")
regionsLimit=$(( ${#regionNames[@]} - 1 ))
#---=== x ===---
#${dd} : "debug output string"

if [ "${1:-}" = "-" ]; then return; fi

if [ $# -lt 2 ]; then
  msg "Usage: ${0} region_# release_date [project_key]"
  echo "  region_# can be:"
  for i in $(seq 2 ${regionsLimit}); do
    echo "    ${i} means ${regionNames[$i]}"
  done
  echo "  release_date may be e.g. 230615
  project_key - default is \"TST\""
  exit
fi

region=${1}

if [ "${region}" -lt 2 ] || [ "${region}" -gt ${regionsLimit} ]; then
  exitMsg "region_# should be from 2 to ${regionsLimit}"
fi

git --version

release=${2}
projectKey=${3:-TST}
jiraTicket=${projectKey}-${region}
baseBranch=${jiraTicket}-${regionNames[${region}]}

git checkout ${baseBranch}
git branch ${baseBranch}-release-${release}
git checkout ${baseBranch}-release-${release}
when=$(date "+%H%M%S")
echo Testing the release ${release} at ${when}.>release${release}_${when}.txt
git add release${release}_${when}.txt
git commit --message="${jiraTicket} Release ${release} test at ${when}. #label release${release}"
git tag ${baseBranch}-tag-${release}
