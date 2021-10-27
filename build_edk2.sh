#!/bin/bash

if [ ! -d edk2 ]; then
    git clone https://github.com/tianocore/edk2.git
fi
if [ ! -d edk2-platforms ]; then
    git clone https://github.com/tianocore/edk2-platforms.git
fi
cd edk2
git submodule init && git submodule update --init --recursive
cd ..
export WORKSPACE=$(pwd)
export PACKAGES_PATH=$WORKSPACE/edk2:$WORKSPACE/edk2-platforms
export ACTIVE_PLATFORM="Platform/StandaloneMm/PlatformStandaloneMmPkg/PlatformStandaloneMmRpmb.dsc"
export GCC5_AARCH64_PREFIX=aarch64-linux-gnu-
source edk2/edksetup.sh
make -C edk2/BaseTools
build -p $ACTIVE_PLATFORM -b RELEASE -a AARCH64 -t GCC5 -n 1
