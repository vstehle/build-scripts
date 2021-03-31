#!/bin/sh

# OPTEE
git clone https://source.codeaurora.org/external/imx/imx-optee-os
git -C imx-optee-os checkout origin/imx_5.4.70_2.3.0 -b linaro-rsb3720
sed "s/UART2_BASE/UART3_BASE/" -i imx-optee-os/core/arch/arm/plat-imx/conf.mk

# TF-A
git clone https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git

git clone https://github.com/ARMmbed/mbedtls.git
git -C mbedtls checkout development

# imx-mkimage
git clone https://git.linaro.org/people/paul.liu/systemready/non-free/imx-mkimage.git
git -C imx-mkimage checkout rel_imx_5.4.24_2.1.0

# U-boot
if [ $USER = paulliu ]; then
    git clone --reference ~/upstream/u-boot https://github.com/ADVANTECH-Corp/uboot-imx.git
else
    git clone https://github.com/ADVANTECH-Corp/uboot-imx.git
fi

git -C uboot-imx checkout adv_v2020.04_5.4.24_2.1.0
