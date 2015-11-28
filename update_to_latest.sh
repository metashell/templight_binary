#!/bin/bash

BRANCH=develop

git clone https://github.com/sabel83/metashell.git tmp
cd tmp
  git checkout origin/${BRANCH}
  git rev-parse HEAD > ../commit
cd ..
rm -rf tmp

COMMIT=$(cat commit)

git add commit
git commit -m "Upgrade to Metashell commit ${COMMIT}"
