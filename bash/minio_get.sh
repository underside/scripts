#!/usr/bin/bash

# ./minio-get.sh
# Usage :: ./minio-get.sh test file1 loalhost 9020 minioadmin minioadmin

bucket=$1
file=$2
host=$3
port=$4
s3_key=$5
s3_secret=$6
buckets_file="/home/i/tmp/buckets"
buckets_report="/home/i/tmp/buckets_report.org"
minio_alias=mprod

api_buckets_get(){

resource="/${bucket}/${file}"
content_type="application/octet-stream"
date=`date -R`
_signature="GET\n\n${content_type}\n${date}\n${resource}"
signature=`echo -en ${_signature} | openssl sha1 -hmac ${s3_secret} -binary | base64`
curl -v -o ./get.${file} -X GET \
          -H "Host: $host" \
          -H "Date: ${date}" \
          -H "Content-Type: ${content_type}" \
          -H "Authorization: AWS ${s3_key}:${signature}" \
          http://$host:$port${resource}
}
