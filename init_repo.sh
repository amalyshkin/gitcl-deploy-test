#!/bin/bash
# ISS Art bash template v.1.4
# set -o xtrace # turn on debugging
# dd="echo ---" # turn on displaying debug output
set -euo pipefail
[ -e "$(dirname "${0}")/isslib.sh" ] && . "$(dirname "${0}")/isslib.sh" || . isslib.sh
#---=== Variables section ===---
#VAR='val' # description
#---=== x ===---
#${dd} : "debug output string"

[ -e "$(dirname "${0}")/release_test.sh" ] && . "$(dirname "${0}")/release_test.sh" - || . release_test.sh -

if [ $# -lt 1 ]; then
  exitMsg "Usage: ${0} go [project_key]
  project_key - default is \"TST\""
fi

git --version

projectKey=${2:-TST}

# the repo may have 'master' branch or may not
git show-branch master &>/dev/null && git checkout master || git checkout -b master
echo The root commit.>master.txt
git add master.txt
git commit --message="${projectKey}-1 The root commit."
git add init_repo.sh push_all_to_remote.sh release_test.sh isslib.sh
git commit --message="${projectKey}-1 All required scripts."
echo spread_push.sh>>.gitignore
git add .gitignore spread_push.sh.template
git commit --message="${projectKey}-1 The template for the push script."
git add ".github/workflows/github-actions-demo.yml" .gitlab-ci.yml azure-pipelines.yml bitbucket-pipelines.yml
git commit --message="${projectKey}-1 CI/CD configurations."

for i in $(seq 2 ${regionsLimit}); do
  git branch ${projectKey}-${i}-${regionNames[${i}]}
  git checkout ${projectKey}-${i}-${regionNames[${i}]}
  echo The branch for region ${regionNames[${i}]}.>${regionNames[${i}]}.md
  git add ${regionNames[${i}]}.md
  git commit --message="${projectKey}-${i} The branch for region ${regionNames[${i}]}."
  git checkout master
done
