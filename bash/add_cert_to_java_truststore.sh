#!/usr/bin/bash

in_cert=/home/i/tmp/ngw.devices.pem
out_cert=/home/i/tmp/ngw.devices.der

# download pem certs
generate_der_certs_from_pem(){
    openssl x509 -outform der -in ${in_cert} -out ${out_cert}
}

add_cert_to_java_truststore(){
keytool -import -alias myalias -keystore cacerts -file ${in_cert}
   
}

### MAIN
# generate_der_certs
# download_cert_from_url
