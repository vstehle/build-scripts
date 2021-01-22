Hardware test in Debian
=======================

## Install firmware-iwlwifi

We need to install latest firmware-iwlwifi package from Debian unstable
to support WiFi

 * On https://packages.qa.debian.org/f/firmware-nonfree.html
 * Click "firmware-iwlwifi" in binaries box
 * Scroll down
 * Click "all"
 * Download the binary package from either mirror
 * Run "sudo dpkg -i firmware-iwlwifi_*_all.deb"

## Check CPU

 * Run "cat /proc/cpuinfo"
 * Make sure there are 4 cores

## Check memory

 * Run "free"
 * Make sure there are at least 2G ram

## Test WiFi

 * "sudo apt install network-manager"
 * reboot
 * Run "nmcli d wifi". You should see it scans the AP

## Test Bluetooth

 * "sudo apt install bluez bluez-tools"
 * reboot
 * Run "hcitool scan"

## Test Ethernet

 * "sudo apt install net-tools"
 * Run "/sbin/ifconfig" and see if it gets the IP address from DHCP server

## Test RTC

 * Run "sudo apt install ntpdate"
 * Run "date" and check if the time is correct.
 * reboot the system
 * Check "date" in U-boot to see if the time is correct (in UTC).

