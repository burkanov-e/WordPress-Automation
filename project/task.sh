#!bin/bash 

var=1200
for i in gp1 gp2 gp3 gp4; do
groupadd -g $var $i
var+=200
done