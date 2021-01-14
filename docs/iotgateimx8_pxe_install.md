Running OS installer on Compulab iot-gate-imx8 by PXE
=========================================================

This document describes running OS installe on iot-gate-imx8
through PXE.

## Setting up DHCP server.

Before using PXE boot. You have to set up a DHCP server.

The following is the /etc/dhcpd.conf

default-lease-time 600;
max-lease-time 7200;

allow booting;

# in this example, we serve DHCP requests from 192.168.0.(3 to 100)
# and we have a router at 192.168.0.1
subnet 192.168.0.0 netmask 255.255.255.0 {
  range 192.168.0.3 192.168.0.100;
  option broadcast-address 192.168.0.255;
  option routers 192.168.0.1;             # our router
  option domain-name-servers 192.168.0.1; # our router, again
  filename "pxelinux.0"; # (this we will provide later)
}

group {
  next-server 192.168.0.1;                # our Server
  host tftpclient {
    filename "di/EFI/BOOT/bootaa64.efi";
  }
}

## Debian

Pre-built D-I image. https://drive.google.com/file/d/1PGLqCIKzCj0HkOaRe1GFmJu7rDFH1AXq/view?usp=sharing

First. Download D-I image.
And then we mkdir a directory in tftp root and extract everything to that
directory.

 1. mkdir /srv/tftp/di
 2. cd /srv/tftp/di; tar zxvf netboot*.tar.gz

We need to create pxelinux.cfg directory in tftp root

 1. mkdir /srv/tftp/pxelinux.cfg

And then we create a config file inside pxeboot.

cat << EOF > /srv/tftp/pxelinux.cfg/default-arm-imx8m
menu title Linux selections

label Debian install
        menu label Default Install Image
        kernel di/debian-installer/arm64/linux
        append console=ttymxc2,115200 earlycon=ec_imx6q,0x30880000,115200
        initrd di/debian-installer/arm64/initrd.gz
EOF

