Running Fedora IoT installer on Compulab iot-gate-imx8
========================================================

This document describes running Fedora IoT installer on iot-gate-imx8
and enabling UEFI secure boot.
It means things not signed by RedHat will not be able to run. For example,
SCT and Debian installer will fail to run.

## Download Fedora IoT installer

Please download Fedora IoT from
https://getfedora.org/iot/download/

And flash the ISO to an USB stick.

## Pre-setting

Before using UEFI secure boot, things in this section needs to be run
once.

### Sync the RTC from NTP server

We better to set the RTC from the NTP server for a correct time.

1. setenv autoload 0; dhcp
2. setenv ntpserverip 118.163.81.61
3. date reset
4. sntp

### Setting UEFI keys

This section describes how to import the UEFI secure boot keys into
U-boot. Once the keys are set, it cannot be changed anymore until you
clean the eMMC.

First, please run gen_keys_fedora_iot.sh under uefi_secboot_keys directory.
Put PK.auth, KEK.auth, db.auth to TFTP server.

In U-boot prompt, run the following commands:
 1. setenv autoload 0; dhcp
 2. setenv serverip <your tftp server ip addr>
 3. tftp ${loadaddr} PK.auth
 4. setenv -e -nv -bs -rt -at -i ${loadaddr}:$filesize PK
 5. tftp ${loadaddr} KEK.auth
 6. setenv -e -nv -bs -rt -at -i ${loadaddr}:$filesize KEK
 7. tftp ${loadaddr} db.auth
 8. setenv -e -nv -bs -rt -at -i ${loadaddr}:$filesize db

And reset the board.

## Boot into Fedora IoT installer

Insert the USB stick with Fedora IoT installer on it to the board.
You should see IoT installer being run after reboot.

If you change the USB stick with Debian installer or SCT, you should
find that U-boot refuse to boot into it.

## Sign the efi.

If the efi binaries are not signed, we need to sign those binaries by
ourselves.
First, we run the script gen_keys_fedora_iot.sh
And it will generate db001.key and db001.crt.
Then we can sign any efi binaries by
"sbsign --key db001.key --cert db001.crt --output signed.efi origin.efi"

## Get certificate from a signed efi.

Any signed efi if we don't have the certificate for it, we can use
extract_cert_from_efi_binary.sh to extract the certificate.
For example, run
"./extract_cert_from_efi_binary.sh shimaa64.efi extra_ca_01.crt"

And put extra_ca_01.crt with gen_keys_fedora_iot.sh.
Run gen_keys_fedora_iot.sh and it will include that crt into db key
so that we can verify the signed efi.

## Go back to setup mode

Go back to setup mode means we need to remove the PK.
It can be done by setting noPK.auth (empty esl signed by PK private key) to
PK variable.
However, noPK.auth must be signed with the same PK private key.
If you lost the private key, this method is not working.
Then you need to temporarily turn on CFG_RPMB_RESET_FAT of OpTEE to
clear the entire rpmb.
