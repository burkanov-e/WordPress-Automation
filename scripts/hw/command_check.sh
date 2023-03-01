#!/bin/bash

read -p "Please enter which command you want to search: " command
gp_wd=$(which $command)

if [[ $(echo $?) == 0 ]]; then
    echo "$command does exist in the system"
else
    echo "$command does not exist"
fi