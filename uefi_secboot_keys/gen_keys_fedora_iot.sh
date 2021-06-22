#!/bin/sh

rm -f KEK.* PK.* rh_ca.* rh_ca_?.* RedHat* extra_ca_*.esl extra_ca_*-c-??.crt

# Generate PK
faketime '2010-10-10 08:15:42' \
	 openssl req -x509 -sha256 -newkey rsa:2048 -subj /CN=TEST_PK/ \
	 -keyout PK.key -out PK.crt -nodes -days 5000
cert-to-efi-sig-list -g 11111111-2222-3333-4444-123456789abc \
  PK.crt PK.esl
faketime '2010-10-10 09:15:42' sign-efi-sig-list -c PK.crt -k PK.key PK PK.esl PK.auth

# Generate KEK
faketime '2011-10-11 08:15:43' \
	 openssl req -x509 -sha256 -newkey rsa:2048 -subj /CN=TEST_KEK/ \
	 -keyout KEK.key -out KEK.crt -nodes -days 5000
cert-to-efi-sig-list -g 11111111-2222-3333-4444-123456789abc \
  KEK.crt KEK.esl
faketime '2011-10-11 09:15:43' sign-efi-sig-list -c PK.crt -k PK.key KEK KEK.esl KEK.auth

# Get Red Hat Test CA
certutil -L -d /etc/pki/pesign -n "Red Hat Test CA" -r > RedHatTestCA.der
certutil -L -d /etc/pki/pesign -n "Red Hat Test Certificate" -r > RedHatTestCertificate.der

# Convert RedHat CA from der to pem
openssl x509 -inform der -in RedHatTestCA.der -out rh_ca.crt
openssl x509 -inform der -in RedHatTestCertificate.der -out rh_ca_2.crt

# db
cert-to-efi-sig-list -g 11111111-2222-3333-4444-123456789abc \
		     rh_ca.crt rh_ca.esl
cert-to-efi-sig-list -g 11111111-2222-3333-4444-123456789abc \
		     rh_ca_2.crt rh_ca_2.esl
for i in extra_ca_*.crt; do
    if [ -e "$i" ]; then
	i1=`basename "$i" .crt`
	openssl pkcs7 -inform pem -print_certs -in "$i" -out "$i1"-1.crt
	csplit -s -z -f "$i1"-c -b "-%02d.crt" "$i1"-1.crt '/-----BEGIN CERTIFICATE-----/' '{*}'
	rm -f "$i1"-1.crt
	for j in "$i1"-c-??.crt; do
	    j1=`basename "$j" .crt`
	    if [ -f "$j" ]; then
		if grep "BEGIN CERTIFICATE-----" "$j"; then
		    cert-to-efi-sig-list \
			-g 11111111-2222-3333-4444-123456789abc \
			"$j" "$j1".esl
		fi
	    fi
	done
    fi
done
cat rh_ca.esl rh_ca_2.esl > rh_ca_3.esl
for i in extra_ca_*.esl; do
    if [ -f "$i" ]; then
	cat "$i" >> rh_ca_3.esl
    fi
done

faketime '2021-06-10 08:15:43' \
	 openssl req -x509 -sha256 -newkey rsa:2048 -subj /CN=TEST_DB/ \
	 -keyout db001.key -out db001.crt -nodes -days 5000
cert-to-efi-sig-list -g 11111111-2222-3333-4444-123456789abc \
		     db001.crt db001.esl
cat db001.esl >> rh_ca_3.esl

faketime '2021-06-10 09:15:43' sign-efi-sig-list -c KEK.crt -k KEK.key db rh_ca_3.esl rh_ca.auth

echo
echo "Generated the following auth files:"
ls *.auth

if [ $USER = paulliu ]; then
    atftp -p -l PK.auth -r PK.auth 192.168.66.10
    atftp -p -l KEK.auth -r KEK.auth 192.168.66.10
    atftp -p -l rh_ca.auth -r rh_ca.auth 192.168.66.10
fi
