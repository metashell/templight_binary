#!/bin/bash

git clone https://github.com/sabel83/metashell.git
cd metashell
  git fetch origin
  git checkout $(cat ../commit)
  ./build.sh
  cd bin
    PLATFORM=$(ls | egrep '\.(deb|rpm)$' | sed 's/^metashell_[^_]*_//' | sed 's/\.\(deb\|rpm\)$//')
  cd ..
  cd 3rd/templight/build/bin
    tar -cvjf ../../../../../templight_${PLATFORM}.tar.bz2 templight*
  cd ../../../..
cd ..

