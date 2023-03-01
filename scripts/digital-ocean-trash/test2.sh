#!/bin/bash

if [[ $(which wget) ]]; then
    echo "$command does exist in the system"
else
    echo "$command does not exist"
fi