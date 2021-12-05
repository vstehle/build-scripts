#!/bin/sh

set -e

if [ -d build ]; then
    rm -rf build
fi

manual_config() {
    sed -i.bak001 '/PLAT_IMX8MM_BOOT_MMC_BASE/s/0x30B50000/0x30B60000/' plat/imx/imx8m/imx8mm/include/platform_def.h
}

restore_manual_config() {
    if [ -e plat/imx/imx8m/imx8mm/include/platform_def.h.bak001 ]; then
	mv -f plat/imx/imx8m/imx8mm/include/platform_def.h.bak001 \
	   plat/imx/imx8m/imx8mm/include/platform_def.h
    fi
}

restore_manual_config
manual_config

make ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu- PLAT=imx8mm \
     SPD=opteed BL32_BASE=0x7e000000 IMX_BOOT_UART_BASE=0x30880000 \
     NEED_BL32=yes NEED_BL33=yes NEED_BL2=yes \
     LOG_LEVEL=50 \
     USE_TBBR_DEFS=1 GENERATE_COT=1 TRUSTED_BOARD_BOOT=1 \
     MBEDTLS_DIR=../mbedtls \
     BL32=../optee_os/build.mx8mmevk/core/tee-header_v2.bin \
     BL32_EXTRA1=../optee_os/build.mx8mmevk/core/tee-pager_v2.bin \
     BL32_EXTRA2=../optee_os/build.mx8mmevk/core/tee-pageable_v2.bin \
     BL33=/tmp/uboot-imx8/u-boot.bin BL2_CFLAGS=-DIMX_FIP_MMAP \
     MEASURED_BOOT=1 \
     fip bl2 bl31

restore_manual_config
