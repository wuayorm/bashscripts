#!/bin/bash
#
# Script to check for regular server updates.
# Created by: Eduardo Rocha
# Version: 2.1
# Modified: 06.22.2017
#
#

# remove previous files
# rm -f /home/erocha/*.txt
# sudo rm -f /home/erocha/backups/*



# define variables
#description=""
description=$(echo "h1.{color:#ff0000}"$(hostname)".esc13.net{color}"'\\u000a')



sudo yum update --assumeno > centos-update.txt
sudo yum update --assumeno | grep "Upgrade" > updates.txt


read_file () {

        while IFS= read -r line
        do
          description=$description$line'\\u000a'
        done < ticket.txt

echo $description
return

}

# Modify the path
if [[ -s /home/erocha/bashscripts/updates.txt ]]; then

	file_lines=$(wc -l < centos-update.txt) 
	((start_lines=$file_lines - 2))

#	sed -e "$start_lines,${file_lines}d" centos-update.txt > ticket.txt
	sed -e "$start_lines,${file_lines}d" centos-update.txt | sed '/Loaded/,/Resolved/ d' > ticket.txt

	summary="Server Updates."
#	description=$(< ticket.txt)
#	description="h1.{color:#ff0000}$(hostname).esc13.net{color}$(< ticket.txt)"
	read_file

	echo "{" >> jira.txt
	echo '"fields": {' >> jira.txt
	echo '"project": {' >> jira.txt
	echo '"key": "ITHELP"' >> jira.txt
	echo "}," >> jira.txt
	echo '"summary":' '"'$summary'"'',' >> jira.txt
	echo -e '"description":' '"'$description'"'',' >> jira.txt
	echo '"issuetype": {' >> jira.txt
	echo '"name": "Task"' >> jira.txt
	echo "}" >> jira.txt
	echo "}" >> jira.txt
	echo "}" >> jira.txt


#	Add log entry for the update.

       # echo "Update $(date +%Y%m%d_%H%M%S) regular update" >> updates.log	
	echo "$(date) regular update" >> updates.log

        echo ""
	echo "New Centos updates!!!!"
        echo ""

else

#	echo "No updates $(date +%Y%m%d_%H%M%S) " >> updates.log
	echo "$(date) No updates" >> updates.log


fi


