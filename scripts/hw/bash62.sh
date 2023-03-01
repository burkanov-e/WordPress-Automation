#!/usr/bin/env bash

mkdir -p /tmp/task2/docs 
touch /tmp/task2/file1.txt /tmp/task2/.hidden.txt
head -n 10 /etc/services > /tmp/task2/saved_top.txt | tail -n 10 /etc/passwd > /tmp/task2/saved_bottom.txt
cp /etc/passwd /tmp/task2/users.txt | mkdir -p /tmp/task2/university/faculty/class && cat -n /tmp/task2/saved_top.txt > /tmp/task2/saved_top_numbered.txt
mkdir /tmp/task2/media && cp /tmp/task2/saved_bottom.txt /tmp/task2/media/ | touch /tmp/task2/jump && find / -name 'jump' -print > /tmp/task2/find_command_out.txt