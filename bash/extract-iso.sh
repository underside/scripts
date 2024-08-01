#!/usr/bin/bash


extract_iso(){
    src_iso_file=/home/i/tmp/ks-preseed/CentOS-7-x86_64-Minimal-2009_ks_v1.3.iso
    isofiles_dir=/home/i/tmp/ks-preseed/centos_iso
    if [ ! -f $src_iso_file ] || [ ! -d $isofiles_dir ]; then
        echo "SRC iso file or DIR not found, please check provided path:
${src_iso_file} ${isofiles_dir}"
       
        exit 2
    fi

    xorriso -osirrox on -indev $src_iso_file  -extract / $isofiles_dir
    chmod +w $isofiles_dir -R
}

extract_iso
