#!/bin/sh

if [ "$1" = "" ] || [ ! -e "$1" ] || [ "$2" = "" ]
then
    echo "Usage: ${0##*/} <binary.efi> <out.pem>"
    exit 64 # EX_USAGE
fi

rm -f "$2"

osslsigncode extract-signature -pem -in "$1" -out "$2"
openssl pkcs7 -inform pem -print_certs -text -in "$2"
