#!/bin/bash

set -e

# Detect platform
if [ "`cat /etc/lsb-release 2>/dev/null | grep DISTRIB_ID`" = "DISTRIB_ID=Ubuntu" ]
then
  # Ubuntu
  if [ "$(lsb_release -rs)" = "12.04" ]
  then
    SOURCES=/etc/apt/sources.list
    if grep clang37 ${SOURCES}
    then
      echo Not extending ${SOURCES}
    else
      TMP=sources.list
      cp ${SOURCES} ${TMP}
      echo >> ${TMP}
      echo "# clang37" >> ${TMP}
      echo "deb http://llvm.org/apt/precise/ llvm-toolchain-precise-3.7 main" >> ${TMP}
      echo "deb-src http://llvm.org/apt/precise/ llvm-toolchain-precise-3.7 main" >> ${TMP}
      echo "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu precise main" >> ${TMP}
      sudo cp ${TMP} ${SOURCES}
      rm ${TMP}
    fi
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y --force-yes install git g++ clang-3.7 libreadline-dev make

    if which cmake
    then
      echo Not building CMake
    else
      mkdir cmake
      cd cmake
        wget https://cmake.org/files/v3.4/cmake-3.4.0.tar.gz --no-check-certificate
        tar -xvzf cmake-3.4.0.tar.gz
        cd cmake-3.4.0
          ./configure
          make
          sudo make install
        cd ..
      cd ..
    fi

    export CXX=clang++-3.7
    export CC=clang-3.7
  fi
fi

# Build
git clone https://github.com/sabel83/metashell.git
cd metashell
  git fetch origin
  git fetch origin '+refs/pull/*/head:refs/remotes/origin/pr/*'
  git checkout $(cat ../commit)
  ./build.sh
  cd bin
    PLATFORM=$(ls)

    cd "$PLATFORM"
      OUT_FILE="../../../templight_${PLATFORM}.tar.bz2"
      rm -f "${OUT_FILE}"
      tar -hcvjf "${OUT_FILE}" templight/bin/templight
      echo "Generated Templight archive: $(basename "${OUT_FILE}")"
    cd ..
  cd ..
cd ..

