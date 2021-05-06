#!/bin/sh

# OPTEE
git clone https://source.codeaurora.org/external/imx/imx-optee-os
git -C imx-optee-os checkout origin/imx_5.4.70_2.3.0 -b linaro-rsb3720
sed "s/UART2_BASE/UART3_BASE/" -i imx-optee-os/core/arch/arm/plat-imx/conf.mk

# TF-A
git clone https://git.linaro.org/people/paul.liu/systemready/trusted-firmware-a.git
git -C trusted-firmware-a checkout paulliu-imx8mp-tbbr

git clone https://github.com/ARMmbed/mbedtls.git
git -C mbedtls checkout development
git -C mbedtls checkout f08ec01e2b4b3c91af8d822a1cdf17c8a5577035 -b test1

# U-boot
if [ $USER = paulliu ]; then
    git clone --reference ~/upstream/u-boot ssh://git@git.linaro.org/people/paul.liu/systemready/u-boot.git
else
    git clone https://git.linaro.org/people/paul.liu/systemready/u-boot.git
fi

git -C u-boot checkout paulliu-rsb3720
