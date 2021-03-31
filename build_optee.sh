#!/bin/sh

set -e

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export CROSS_COMPILE64=aarch64-linux-gnu-

#make PLATFORM=imx PLATFORM_FLAVOR=mx8mpevk O=build.mx8mpevk \
#     CFG_TEE_CORE_LOG_LEVEL=4 \
#     CFG_TEE_TA_LOG_LEVEL=4 \
#     CFG_TEE_CORE_DEBUG=y \
#     CFG_DEBUG_INFO=y

./scripts/nxp_build.sh mx8mpevk
