#!/bin/sh

git clone https://git.linaro.org/people/paul.liu/systemready/optee_os.git
git -C optee_os checkout linaro-master-cl-iot-gate

git clone https://git.linaro.org/people/paul.liu/systemready/trusted-firmware-a.git
git -C trusted-firmware-a checkout imx8-tbbr-3

git clone https://github.com/ARMmbed/mbedtls.git
git -C mbedtls checkout development
git -C mbedtls checkout bd21b18a1faa08705ac6d9980794c181e645f53a -b test1

if [ $USER = paulliu ]; then
    git clone --reference ~/upstream/u-boot ssh://git@git.linaro.org/people/paul.liu/systemready/u-boot.git
else
    git clone https://git.linaro.org/people/paul.liu/systemready/u-boot.git
fi

git -C u-boot checkout iot-gate-imx8-paulliu-master
