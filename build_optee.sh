#!/bin/sh

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export CROSS_COMPILE64=aarch64-linux-gnu-

./scripts/nxp_build.sh mx8mmevk
