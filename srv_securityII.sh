#!/bin/bash
#
# Script to check for security updates.
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



sudo yum update --security --assumeno > /home/erocha/bashscripts/centos-update.txt
sudo yum update --security --assumeno | grep "Upgrade" > /home/erocha/bashscripts/security.txt


read_file () {

        while IFS= read -r line
        do
          description=$description$line'\\u000a'
        done < /home/erocha/bashscripts/ticket.txt

echo $description
return

}

# Modify the path

if [[ -s /home/erocha/bashscripts/security.txt ]]; then

	file_lines=$(wc -l < /home/erocha/bashscripts/centos-update.txt) 
	((start_lines=$file_lines - 2))

#	sed -e "$start_lines,${file_lines}d" centos-update.txt > ticket.txt
	sed -e "$start_lines,${file_lines}d" /home/erocha/bashscripts/centos-update.txt | sed '/Loaded/,/Resolved/ d' > /home/erocha/bashscripts/ticket.txt

	summary="SECURITY UPDATES. -> "$(hostname -s)".esc13.net"
#	description=$(< ticket.txt)
#	description="h1.{color:#ff0000}$(hostname).esc13.net{color}$(< ticket.txt)"
	read_file

	echo "{" >> /home/erocha/bashscripts/jira-sec.txt
	echo '"fields": {' >> /home/erocha/bashscripts/jira-sec.txt
	echo '"project": {' >> /home/erocha/bashscripts/jira-sec.txt
	echo '"key": "ITHELP"' >> /home/erocha/bashscripts/jira-sec.txt
	echo "}," >> /home/erocha/bashscripts/jira-sec.txt
	echo '"summary":' '"'$summary'"'',' >> /home/erocha/bashscripts/jira-sec.txt
	echo -e '"description":' '"'$description'"'',' >> /home/erocha/bashscripts/jira-sec.txt
	echo '"issuetype": {' >> /home/erocha/bashscripts/jira-sec.txt
	echo '"name": "Task"' >> /home/erocha/bashscripts/jira-sec.txt
        echo "}," >> /home/erocha/bashscripts/jira-sec.txt
        echo '"priority": {' >> /home/erocha/bashscripts/jira-sec.txt
        echo '"name": "High"' >> /home/erocha/bashscripts/jira-sec.txt
	echo "}" >> /home/erocha/bashscripts/jira-sec.txt
	echo "}" >> /home/erocha/bashscripts/jira-sec.txt
	echo "}" >> /home/erocha/bashscripts/jira-sec.txt


#	Add log entry for the update.

       # echo "Update $(date +%Y%m%d_%H%M%S) SECURITY UPDATES!!!" >> updates.log	
	echo "$(date) SECURITY UPDATES!!!" >> /home/erocha/bashscripts/updates.log

        echo ""
	echo "New Centos security updates!!!!"
        echo ""

else

	# echo "No Security updates!!! $(date +%Y%m%d_%H%M%S) " >> updates.log
	echo "$(date) No security updates!!!" >> /home/erocha/bashscripts/updates.log


fi


