#!/usr/bin/env bash

read -p "Please enter a folder name: " folder
read -p "Please enter a sub folder name: " sub_folder
read -p "Please enter a file name: " file_name
read -p "Please enter the text to be written in the file: " text_name

mkdir -p $folder/$sub_folder && echo "$text_name" > $folder/$sub_folder/$file_name.txt 
cat $folder/$sub_folder/$file_name.txt > /tmp/"$file_name"_output.txt

read -p "Please enter a name for your password output file: " passwd_out_file
read -p "Please enter a name for your group output file: " group_out_file

head -n 5 /etc/passwd > /tmp/$passwd_out_file.txt | tail -n 5 /etc/passwd > /tmp/$group_out_file.txt
cp /tmp/$passwd_out_file.txt /tmp/$group_out_file.txt $folder/$sub_folder/

read -p "Please enter a name where your OS info will be stored: " os_info
read -p "Please enter a word to search in /etc/passwd file: " grep_word

cat /etc/os-release > /tmp/$os_info.txt | grep -n "$grep_word" /etc/passwd > $folder/$sub_folder/grep_out_"$grep_word".txt

read -p "How many folders do you want to be created (Please provide a digit): " num_folders
read -p "Please provide a name for your folder: " name_folder

for i in $(seq 1 $num_folders); do
  mkdir "/tmp/${name_folder}$i"
done

for i in $(seq 1 $((num_folders - 1))); do 
    mkdir "/tmp/${name_folder}$i"
    mv /tmp/$name_folder$i /tmp/$name_folder$num_folders/
done

wc $folder/$sub_folder/$passwd_out_file.txt > /tmp/$name_folder$num_folders/

cat /etc/os-release && who && cat /proc/meminfo && df -H --output=size,used,avail

$1 $2 install.sh foldername subfolder_name














# echo "Please enter the name for your directory"
# read maindir
# mkdir $maindir
# echo "Please enter the name for your sub-directory"
# read subdir  
# cd $maindir 
# mkdir $subdir 
# cd $subdir
# echo "Please enter the name for your text file"
# read usertxt
# echo "Hello World!" > $usertxt.txt /tmd

#read -p
#tee
# &&