#! /usr/bin/env bash
set -euxo nounset
(( $UID ))
if (( ! $# )) ; then
  M=update
else M="$*"
fi
pwd
git add .
git commit -m "$M"
git push --set-upstream origin HEAD:ubuntu
cd  ..
git add .
git commit -m "$M"
git push

