#!/bin/bash

basename=$1
if [ "$1" == "" ]; then
	echo "useage: $0 <basename>"
	echo "such as $0 platform"
	exit 1
fi

export_pass=expass

echo "convert to pkcs8 format"
openssl pkcs8 -in ${basename}.pk8 -inform DER -outform PEM -out ${basename}.priv.pem -nocrypt
echo "convert to pkcs12 format"
openssl pkcs12 -export -in ${basename}.x509.pem -inkey ${basename}.priv.pem -out ${basename}.pk12 -name androiddebugkey -passout pass:${export_pass}
echo "import to ${basename}.keystore"
keytool -importkeystore -deststorepass android -destkeypass android -destkeystore ${basename}.keystore -srckeystore ${basename}.pk12 -srcstoretype PKCS12 -srcstorepass ${export_pass} -alias androiddebugkey
echo "import to android.keystore"
keytool -importkeystore -deststorepass android -destkeypass android -destkeystore android.keystore -srckeystore ${basename}.pk12 -srcstoretype PKCS12 -srcstorepass expass -srcalias androiddebugkey -destalias android${basename};
# remove intermediate files
rm ${basename}.priv.pem
rm ${basename}.pk12
