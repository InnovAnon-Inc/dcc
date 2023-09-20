#! /usr/bin/env bash
set -euxo nounset
(( $UID ))
if (( ! $# )) ; then
  M=update
else M="$*"
fi
git add .
git commit -m "$M"
git push --set-upstream origin HEAD:voidlinux
cd  ..
git add .
git commit -m "$M"
git push

