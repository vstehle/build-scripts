#!/bin/sh

set -e

if [ -d build ]; then
    rm -rf build
fi

make ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu- PLAT=imx8mp \
     IMX_BOOT_UART_BASE=0x30880000 \
     SPD=opteed NEED_BL2=yes NEED_BL32=yes NEED_BL33=yes \
     LOG_LEVEL=50 \
     USE_TBBR_DEFS=1 GENERATE_COT=1 TRUSTED_BOARD_BOOT=1 \
     MBEDTLS_DIR=../mbedtls \
     BL32=../imx-optee-os/build.mx8mpevk/core/tee-header_v2.bin \
     BL32_EXTRA1=../imx-optee-os/build.mx8mpevk/core/tee-pager_v2.bin \
     BL32_EXTRA2=../imx-optee-os/build.mx8mpevk/core/tee-pageable_v2.bin \
     BL33=/tmp/uboot-imx8mp/u-boot.bin \
     fip bl2 bl31
