#!/bin/bash

for i in {1..20}; do dd if=/dev/zero of=file$i bs=1 count=0 seek=1G;

zip_check=$(which zip)

if [[ $(echo $?) == 0 ]]; then
    for i in {1..20}; do
        do zip test.zip file$i; 
    done 
else
    yum install -y zip 
    for i in {1..20}; do
        do zip test.zip file$i; 
    done 
fi

mkdir zip gzip bzip2 tar

unzip_check=$(which unzip)

if [[ $(echo $?) == 0 ]]; then
    cd zip
    unzip ~root/compression/test.zip
else
    yum install -y unzip 
    cd zip
    unzip ~root/compression/test.zip 
fi


for i in {1..20}; do
    zip test.zip file$i; 
done 









    