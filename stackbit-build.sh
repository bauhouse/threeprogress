#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5e3a004eb10f8b0019b304bc/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e3a004eb10f8b0019b304bc
curl -s -X POST https://api.stackbit.com/project/5e3a004eb10f8b0019b304bc/webhook/build/ssgbuild > /dev/null
gatsby build
wait

curl -s -X POST https://api.stackbit.com/project/5e3a004eb10f8b0019b304bc/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
