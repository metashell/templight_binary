#!/bin/bash

if [ -z "${BRANCH}" ]
then
  BRANCH=master
fi

if [ -z "${OWNER}" ]
then
  OWNER=sabel83
fi

git clone https://github.com/${OWNER}/metashell.git tmp
cd tmp
  git checkout origin/${BRANCH}
  git rev-parse HEAD > ../commit
cd ..
rm -rf tmp

COMMIT=$(cat commit)

git add commit
git commit -m "Upgrade to Metashell commit ${COMMIT}"
