#!/bin/bash


 file_lines=$(wc -l < /home/erocha/bashscripts/centos-update.txt) 
 ((start_lines=$file_lines - 2))

# sed -e "$start_lines,${file_lines}d" centos-update.txt > ticket.txt
 sed -e "$start_lines,${file_lines}d" /home/erocha/bashscripts/centos-update.txt | sed '/Loaded/,/Resolved/ d' > /home/erocha/bashscripts/ticket.txt
 