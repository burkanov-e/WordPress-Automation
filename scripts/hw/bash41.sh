#!/bin/bash

read -p "Please enter how many folders you want to create " num_folders

mkdir -p /root/folder{1..num_folders}

