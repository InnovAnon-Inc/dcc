#! /usr/bin/env bash
set -euxo nounset
(( $#   ))
(( $UID ))
[[ "$*" ]]
git add .
git commit -m "$*" || :
#git pull      origin
git branch    "$*"
git checkout  "$*"
git checkout  voidlinux
git merge     "$*"
git push origin HEAD:voidlinux

while [[ "$(basename "$(pwd)")" != teamhack ]]
do cd ..
done
git add .
git commit -m "$*"
git pull
git push
