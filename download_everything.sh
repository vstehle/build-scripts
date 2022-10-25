#!/bin/sh

# OPTEE
git clone https://git.linaro.org/people/paul.liu/systemready/optee_os.git
git -C optee_os checkout 26fc000f
git -C optee_os am ../patches/0001-Fix-link-with-ld-2.39.patch

# TF-A
git clone https://git.linaro.org/people/paul.liu/systemready/trusted-firmware-a.git
git -C trusted-firmware-a checkout 24dc0a289

git clone https://github.com/ARMmbed/mbedtls.git
git -C mbedtls checkout f08ec01e2b4b3c91af8d822a1cdf17c8a5577035

# U-boot
if [ x"$USER" = xpaulliu ]; then
    git clone --reference ~/upstream/u-boot ssh://git@git.linaro.org/people/paul.liu/systemready/u-boot.git
else
    git clone https://git.linaro.org/people/paul.liu/systemready/u-boot.git
fi

git -C u-boot checkout paulliu-rsb3720-2
