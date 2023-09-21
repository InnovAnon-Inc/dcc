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
git checkout  ubuntu
git merge     "$*"
git push origin HEAD:ubuntu

while [[ "$(basename "$(pwd)")" != teamhack ]]
do cd ..
done
git add .
git commit -m "$*"
git pull
git push
