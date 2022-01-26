#!/bin/sh

set -e

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export CROSS_COMPILE64=aarch64-linux-gnu-

ln -sf ../Build/MmStandaloneRpmb/RELEASE_GCC5/FV/BL32_AP_MM.fd

if [ x"$SDCARD" = x"" ]; then

make PLATFORM=imx PLATFORM_FLAVOR=mx8mp_rsb3720_6g O=build.mx8mpevk \
     CFG_TEE_CORE_LOG_LEVEL=2 \
     CFG_TEE_TA_LOG_LEVEL=2 \
     CFG_TEE_CORE_DEBUG=y \
     CFG_DEBUG_INFO=y \
     CFG_DT_ADDR=0x52000000 \
     CFG_EXTERNAL_DTB_OVERLAY=y \
     CFG_DT=y \
     CFG_RPMB_FS=y \
     CFG_RPMB_FS_DEV_ID=2 \
     CFG_RPMB_WRITE_KEY=y \
     CFG_RPMB_RESET_FAT=n \
     CFG_STMM_PATH=BL32_AP_MM.fd

else
make PLATFORM=imx PLATFORM_FLAVOR=mx8mp_rsb3720_6g O=build.mx8mpevk \
     CFG_TEE_CORE_LOG_LEVEL=2 \
     CFG_TEE_TA_LOG_LEVEL=2 \
     CFG_TEE_CORE_DEBUG=y \
     CFG_DEBUG_INFO=y \
     CFG_DT_ADDR=0x52000000 \
     CFG_EXTERNAL_DTB_OVERLAY=y \
     CFG_DT=y 
fi

#env CFG_TEE_CORE_LOG_LEVEL=2 \
#    CFG_DT_ADDR=0x52000000 \
#    CFG_EXTERNAL_DTB_OVERLAY=y \
#    CFG_DT=y \
#    ./scripts/nxp_build.sh mx8mpevk

rm -f BL32_AP_MM.fd
