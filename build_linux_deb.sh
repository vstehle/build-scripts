#!/bin/sh

SELFPID=$$
renice 10 -p "$SELFPID"
ionice -c 3 -p "$SELFPID"

S=`pwd`

B="/tmp/linux-deb-imx8"
rm -rf "$B"
mkdir -p "$B"
cd "$B"

git clone --reference "$S" "$S" linux

cd linux

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

nice -10 ionice -c 3 make iot-gate-imx8_defconfig
nice -10 ionice -c 3 make LOCALVERSION=.paulliu-1-arm64 KDEB_PKGVERSION=$(make kernelversion)-1 deb-pkg
