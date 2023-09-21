#! /usr/bin/env bash
set -euxo nounset
(( $UID ))
if (( ! $# )) ; then
  M=update
else M="$*"
fi
pwd
git add .
git commit -m "$M" || :
<<<<<<< HEAD
git push --set-upstream origin HEAD:ubuntu
=======
git push --set-upstream origin HEAD:main
>>>>>>> 08d7430cd9f7241d7a6055e073bf7b38b8efa4bf
cd  ..
git add .
git commit -m "$M" || :
git push

