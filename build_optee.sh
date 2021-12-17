#!/bin/sh

set -e

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export CROSS_COMPILE64=aarch64-linux-gnu-

make PLATFORM=imx PLATFORM_FLAVOR=mx8mp_rsb3720_6g O=build.mx8mpevk \
     CFG_TEE_CORE_LOG_LEVEL=2 \
     CFG_TEE_TA_LOG_LEVEL=2 \
     CFG_TEE_CORE_DEBUG=y \
     CFG_DEBUG_INFO=y \
     CFG_DT_ADDR=0x52000000 \
     CFG_EXTERNAL_DTB_OVERLAY=y \
     CFG_DT=y

#env CFG_TEE_CORE_LOG_LEVEL=2 \
#    CFG_DT_ADDR=0x52000000 \
#    CFG_EXTERNAL_DTB_OVERLAY=y \
#    CFG_DT=y \
#    ./scripts/nxp_build.sh mx8mpevk
