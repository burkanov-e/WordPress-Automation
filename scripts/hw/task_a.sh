#!bin/bash

for i in anna bob amy; do
useradd $i
getfacl etc/passwd | awk -F'::' 'NR > 3 && NR <=6{print $2}'

done