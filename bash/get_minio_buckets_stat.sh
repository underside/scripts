#!/usr/bin/bash

#### Global vars
buckets_file="/home/i/tmp/buckets"
buckets_report="/home/i/tmp/buckets_report.org"
minio_alias=mprod

clean(){
    rm $bucket_report
}

collect_buckets_to_file(){
    mc ls mprod | awk {'print $5'} > $buckets_file
}


get_buckets_stat(){
    readarray buckets_arr < $buckets_file
    for bc in "${buckets_arr[@]}"; do
        echo "Processing bucket ${bc}..."
        echo "* $bc" >> $buckets_report
        mc du --depth 1 $minio_alias/$bc >> $buckets_report
    done
    
}



#### MAIN
#collect_buckets_to_file
#get_buckets_stat


