#!/bin/bash
#
# Script to check for regular server updates.
# Created by: Eduardo Rocha
# Version: 2.3
# Modified: 09.21.2017
#
#

# remove previous files
 rm -f /home/erocha/*.txt
 rm -f /home/erocha/bashscripts/*.txt
# sudo rm -f /home/erocha/backups/*



# define variables
#description=""
description=$(echo "h1.{color:#ff0000}"$(hostname -s)".esc13.net{color}"'\\u000a')



sudo yum update --assumeno > /home/erocha/bashscripts/centos-update.txt
sudo yum update --assumeno | grep "Upgrade" > /home/erocha/bashscripts/updates.txt


read_file () {

        while IFS= read -r line
        do
          description=$description$line'\\u000a'
        done < /home/erocha/bashscripts/ticket.txt

echo $description
return

}

# Modify the path
if [[ -s /home/erocha/bashscripts/updates.txt ]]; then

	file_lines=$(wc -l < /home/erocha/bashscripts/centos-update.txt) 
	((start_lines=$file_lines - 2))

#	sed -e "$start_lines,${file_lines}d" centos-update.txt > ticket.txt
	sed -e "$start_lines,${file_lines}d" centos-update.txt | sed '/Loaded/,/Resolved/ d' > /home/erocha/bashscripts/ticket.txt

	summary="Server Updates. -> "$(hostname -s)".esc13.net"
#	description=$(< ticket.txt)
#	description="h1.{color:#ff0000}$(hostname).esc13.net{color}$(< ticket.txt)"
	read_file

	echo "{" >> /home/erocha/bashscripts/jira.txt
	echo '"fields": {' >> /home/erocha/bashscripts/jira.txt
	echo '"project": {' >> /home/erocha/bashscripts/jira.txt
	echo '"key": "ITHELP"' >> /home/erocha/bashscripts/jira.txt
	echo "}," >> /home/erocha/bashscripts/jira.txt
	echo '"summary":' '"'$summary'"'',' >> /home/erocha/bashscripts/jira.txt
	echo -e '"description":' '"'$description'"'',' >> /home/erocha/bashscripts/jira.txt
	echo '"issuetype": {' >> /home/erocha/bashscripts/jira.txt
	echo '"name": "Task"' >> /home/erocha/bashscripts/jira.txt
	echo "}" >> /home/erocha/bashscripts/jira.txt
	echo "}" >> /home/erocha/bashscripts/jira.txt
	echo "}" >> /home/erocha/bashscripts/jira.txt


#	Add log entry for the update.

       # echo "Update $(date +%Y%m%d_%H%M%S) regular update" >> updates.log	
	echo "$(date) regular update" >> /home/erocha/bashscripts/updates.log

        echo ""
	echo "New Centos updates!!!!"
        echo ""

else

#	echo "No updates $(date +%Y%m%d_%H%M%S) " >> updates.log
	echo "$(date) No updates" >> /home/erocha/bashscripts/updates.log


fi


