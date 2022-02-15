#!/bin/sh

rm -f KEK.* PK.* rh_ca.* rh_ca_?.* db.* RedHat* extra_ca_*.esl \
   extra_ca_*-c-??.crt DB_test.*

# Generate PK
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=TEST_PK/" \
	-keyout PK.key -out PK.crt -days 3650 -nodes -sha256

# Generate KEK
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=TEST_KEK/" \
	-keyout KEK.key -out KEK.crt -days 3650 -nodes -sha256

# Generate DB key.
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Test_DB/" \
	-keyout DB_test.key -out DB_test.crt -days 3650 -nodes -sha256

GUID=`uuidgen`

# Convert crt to esl
cert-to-efi-sig-list -g $GUID PK.crt PK.esl
cert-to-efi-sig-list -g $GUID KEK.crt KEK.esl
cert-to-efi-sig-list -g $GUID DB_test.crt db.esl

sign-efi-sig-list \
    -t "$(date --date='1 second' +'%Y-%m-%d %H:%M:%S')" \
    -c PK.crt -k PK.key PK PK.esl PK.auth

rm -rf noPK.esl
touch noPK.esl
sign-efi-sig-list \
    -t "$(date --date='2 second' +'%Y-%m-%d %H:%M:%S')" \
    -k PK.key -c PK.crt PK noPK.esl noPK.auth

# Add MS KEK
openssl x509 -inform der -in MicCorKEKCA2011_2011-06-24.crt -out MicCorKEKCA2011_2011-06-24-2.crt
cert-to-efi-sig-list -g $GUID MicCorKEKCA2011_2011-06-24-2.crt KEK_MS.esl
cat KEK_MS.esl >> KEK.esl
# Add RedHat KEK
sign-efi-sig-list \
    -t "$(date --date='3 second' +'%Y-%m-%d %H:%M:%S')" \
    -c PK.crt -k PK.key KEK KEK.esl KEK.auth

# Get Red Hat Test CA
certutil -L -d /etc/pki/pesign -n "Red Hat Test CA" -r > RedHatTestCA.der
certutil -L -d /etc/pki/pesign -n "Red Hat Test Certificate" -r > RedHatTestCertificate.der

# Convert RedHat CA from der to pem
openssl x509 -inform der -in RedHatTestCA.der -out rh_ca.crt
openssl x509 -inform der -in RedHatTestCertificate.der -out rh_ca_2.crt

# db for RedHat
cert-to-efi-sig-list -g $GUID rh_ca.crt rh_ca.esl
cert-to-efi-sig-list -g $GUID rh_ca_2.crt rh_ca_2.esl
cat rh_ca.esl >> db.esl
cat rh_ca_2.esl >> db.esl

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
			-g $GUID \
			"$j" "$j1".esl
		fi
	    fi
	done
    fi
done
#for i in extra_ca_*.esl; do
#    if [ -f "$i" ]; then
#	cat "$i" >> db.esl
#    fi
#done

sign-efi-sig-list \
    -t "$(date --date='4 second' +'%Y-%m-%d %H:%M:%S')" \
    -k KEK.key -c KEK.crt db db.esl db.auth

echo
echo "Generated the following auth files:"
ls *.auth

if [ $USER = paulliu ]; then
    atftp -p -l PK.auth -r PK.auth 192.168.66.10
    atftp -p -l noPK.auth -r noPK.auth 192.168.66.10
    atftp -p -l KEK.auth -r KEK.auth 192.168.66.10
    atftp -p -l db.auth -r db.auth 192.168.66.10
fi
