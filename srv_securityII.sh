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



sudo yum update --security --assumeno > centos-update.txt
sudo yum update --security --assumeno | grep "Upgrade" > security.txt


read_file () {

        while IFS= read -r line
        do
          description=$description$line'\\u000a'
        done < ticket.txt

echo $description
return

}

# Modify the path

if [[ -s /home/erocha/bashscripts/security.txt ]]; then

	file_lines=$(wc -l < centos-update.txt) 
	((start_lines=$file_lines - 2))

#	sed -e "$start_lines,${file_lines}d" centos-update.txt > ticket.txt
	sed -e "$start_lines,${file_lines}d" centos-update.txt | sed '/Loaded/,/Resolved/ d' > ticket.txt

	summary="SECURITY UPDATES."
#	description=$(< ticket.txt)
#	description="h1.{color:#ff0000}$(hostname).esc13.net{color}$(< ticket.txt)"
	read_file

	echo "{" >> jira-sec.txt
	echo '"fields": {' >> jira-sec.txt
	echo '"project": {' >> jira-sec.txt
	echo '"key": "ITHELP"' >> jira-sec.txt
	echo "}," >> jira-sec.txt
	echo '"summary":' '"'$summary'"'',' >> jira-sec.txt
	echo -e '"description":' '"'$description'"'',' >> jira-sec.txt
	echo '"issuetype": {' >> jira-sec.txt
	echo '"name": "Task"' >> jira-sec.txt
        echo "}," >> jira-sec.txt
        echo '"priority": {' >> jira-sec.txt
        echo '"name": "High"' >> jira-sec.txt
	echo "}" >> jira-sec.txt
	echo "}" >> jira-sec.txt
	echo "}" >> jira-sec.txt


#	Add log entry for the update.

       # echo "Update $(date +%Y%m%d_%H%M%S) SECURITY UPDATES!!!" >> updates.log	
	echo "$(date) SECURITY UPDATES!!!" >> updates.log

        echo ""
	echo "New Centos security updates!!!!"
        echo ""

else

	# echo "No Security updates!!! $(date +%Y%m%d_%H%M%S) " >> updates.log
	echo "$(date) No security updates!!!" >> updates.log


fi


