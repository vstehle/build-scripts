#!/bin/sh

DEV1="/dev/serial/by-id/usb-Silicon_Labs_CP2104_USB_to_UART_Bridge_Controller_01EC7550-if00-port0"
DEV2="/dev/serial/by-id/usb-Silicon_Labs_CP2104_USB_to_UART_Bridge_Controller_01EC743D-if00-port0"

DEV="/dev/null"

if [ -e $DEV1 ]; then
    DEV=$DEV1
elif [ -e $DEV2 ]; then
    DEV=$DEV2
fi

if [ $DEV = /dev/null ]; then
    echo "Didn't found any devices"
    exit 1
fi

exec minicom -D "$DEV" -C /tmp/minicom-log_`date +%F_%T`.txt -o -w -b 115200
