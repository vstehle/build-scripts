#!/bin/sh

SELFPID=$$
renice 10 -p "$SELFPID"
ionice -c 3 -p "$SELFPID"

B="/tmp/linux-rsb3720"
rm -rf "$B"
mkdir -p "$B"

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

nice -10 ionice -c 3 make O="$B" imx_v8_adv_defconfig
nice -10 ionice -c 3 make O="$B" 
