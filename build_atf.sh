#!/bin/sh

set -e

if [ -d build ]; then
    rm -rf build
fi

manual_config() {
    #sed -i.bak001 '/#include <platform_def.h>/a #define IMX8M_FIP_MMAP' plat/imx/imx8m/imx8m_io_storage.c
    echo "."
}

restore_manual_config() {
    if [ -e plat/imx/imx8m/imx8m_io_storage.c.bak001 ]; then
	mv -f plat/imx/imx8m/imx8m_io_storage.c.bak001 \
	   plat/imx/imx8m/imx8m_io_storage.c
    fi
}

restore_manual_config

manual_config

make ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu- PLAT=imx8mp \
     IMX_BOOT_UART_BASE=0x30880000 \
     SPD=opteed NEED_BL2=yes NEED_BL32=yes NEED_BL33=yes \
     LOG_LEVEL=50 \
     USE_TBBR_DEFS=1 GENERATE_COT=1 TRUSTED_BOARD_BOOT=1 \
     MBEDTLS_DIR=../mbedtls \
     BL32=../optee_os/build.mx8mpevk/core/tee-header_v2.bin \
     BL32_EXTRA1=../optee_os/build.mx8mpevk/core/tee-pager_v2.bin \
     BL32_EXTRA2=../optee_os/build.mx8mpevk/core/tee-pageable_v2.bin \
     BL33=/tmp/uboot-imx8mp/u-boot.bin BL2_CFLAGS=-DIMX_FIP_MMAP \
     fip bl2 bl31

restore_manual_config
