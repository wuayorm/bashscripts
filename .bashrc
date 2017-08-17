# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Version : 1.0.2
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# Global variables
export PATH=$PATH:/home/erocha/bashscripts


exten="tar.gz"
wikisite="/opt/atlassian/confluence/bin"
jirasite="/opt/atlassian/jira/bin"
crowdsite="/opt/atlassian-crowd-2.9.1"


function fbackup() {


  if [ -z $1 ]; then
     echo ""
     echo "*******************************************"
     echo "Missing parameter for the application name "
     echo "Usage: fbackup <application_name>"
     echo "Examples: fbackup jira; fbackup confluence"
     echo ""
     return 1
  else
     backupdate=""
     srvname=$(hostname)
     sudo rm -f /home/erocha/backups/*
  fi


  if [[ $1 == "confluence" && -f $wikisite/start-confluence.sh ]]; then

        install_dirname="CONFLUENCE_installation_dir_backup_"
        home_dirname="CONFLUENCE_home_dir_backup_"
        install_dir="/opt/atlassian/confluence"
        home_dir="/var/atlassian/application-data/confluence"
        full_pckg="CONFLUENCE_FULLPACKAGE_"
        backupdate=$(date +%Y%m%d_%H%M%S)

        echo ""
        echo "Creating a full backup of WIKI server"
        echo "this will take a moment"
        echo "Creating backup of installation directory..."
        echo ""
        sleep 4
        sudo tar -zcvf ~/backups/$install_dirname$backupdate.$exten $install_dir
        echo ""
        echo "Installation directory backup complete ***"
        echo ""
        echo "Creating backup of home directory..."
        echo ""
        sleep 3
        sudo tar -zcvf ~/backups/$home_dirname$backupdate.$exten $home_dir
        echo ""
        echo "Home directory backup complete ***"
        echo ""
        echo "Creating full backup package..."
        echo ""
        sleep 3
        sudo tar -zcvf ~/backups/$full_pckg$backupdate.$exten ~/backups/$install_dirname$backupdate.$exten ~/backups/$home_dirname$backupdate.$exten --remove-files
        echo "Full backup complete!!!"
        echo ""
        return 1


  elif [[ $1 == "jira" && -f $jirasite/start-jira.sh ]]; then

	install_dirname="JSD_installation_dir_backup_"
	home_dirname="JSD_home_dir_backup_"
	install_dir="/opt/atlassian/jira"
	home_dir="/var/atlassian/application-data/jira"
	full_pckg="JSD_FULLPACKAGE_"
        backupdate=$(date +%Y%m%d_%H%M%S)

        echo ""
        echo "Creating a full backup of JIRA Service Desk"
        echo "this will take a moment"
        echo "Creating backup of installation directory..."
        echo ""
        sleep 4 
        sudo tar -zcvf ~/backups/$install_dirname$backupdate.$exten $install_dir
        echo ""
        echo "Installation directory backup complete ***"
        echo ""
        echo "Creating backup of home directory..."
        echo ""
        sleep 3
        sudo tar -zcvf ~/backups/$home_dirname$backupdate.$exten $home_dir
        echo ""
        echo "Home directory backup complete ***"
        echo ""
        echo "Creating full backup package..."
        echo ""
        sleep 3
        sudo tar -zcvf ~/backups/$full_pckg$backupdate.$exten ~/backups/$install_dirname$backupdate.$exten ~/backups/$home_dirname$backupdate.$exten --remove-files
        echo "Full backup complete!!!"
        echo ""
        return 1

  elif [[ $1 == "crowd" && -f $crowdsite/start_crowd.sh ]]; then

        install_dirname="CROWD_installation_dir_backup_"
        home_dirname="CROWD_home_dir_backup_"
        install_dir="/opt/atlassian-crowd-2.9.1"
        home_dir="/var/crowd-home"
        full_pckg="CROWD_FULLPACKAGE_"
        backupdate=$(date +%Y%m%d_%H%M%S)

        echo ""
        echo "Creating a full backup of CROWD server"
        echo "this will take a moment"
        echo "Creating backup of installation directory..."
        echo ""
        sleep 4
        sudo tar -zcvf ~/backups/$install_dirname$backupdate.$exten $install_dir
        echo ""
        echo "Installation directory backup complete ***"
        echo ""
        echo "Creating backup of home directory..."
        echo ""
        sleep 3
        sudo tar -zcvf ~/backups/$home_dirname$backupdate.$exten $home_dir
        echo ""
        echo "Home directory backup complete ***"
        echo ""
        echo "Creating full backup package..."
        echo ""
        sleep 3
        sudo tar -zcvf ~/backups/$full_pckg$backupdate.$exten ~/backups/$install_dirname$backupdate.$exten ~/backups/$home_dirname$backupdate.$exten --remove-files
        echo "Full backup complete!!!"
        echo ""

        return 1


  else
	echo ""
	echo "Application $1 not found on this server: $srvname "
	echo "please make sure to type de correct name."
	echo ""
	echo "valid names are crowd, confluence or jira"
	echo ""
	return 1


  fi


}


function dbbackup() {

datadir="/data/var/lib/mysql"
sudo rm -f /home/erocha/backups/*

 if [[ -d $datadir/confluence && -d $datadir/jiradb && -d $datadir/crowd ]]; then
	backupdate=""
        wikifile="confluence_backup_"
        jirafile="jira_backup_"
        crowdfile="crowd_backup_"

        backupdate=$(date +%Y%m%d_%H%M%S)
        exten="sql"

        file1=$wikifile$backupdate.$exten
        file2=$jirafile$backupdate.$exten
        file3=$crowdfile$backupdate.$exten

        echo "Backing up Crowd database...."
        sleep 3
        mysqldump -u root -h test-atldb.esc13.net crowd | gzip -c > ~/backups/$file3.gz
        echo "Crowd database backup complete!!"
        echo ""

        echo "Backing up JIRA Service Desk database..."
        sleep 2
        mysqldump -u root -h itest-atldb.esc13.net jiradb | gzip -c > ~/backups/$file2.gz
        echo "JIRA Service Desk database backup complete!!"
        echo ""

        echo "Backing up WIKI database..."
        sleep 2
        mysqldump -u root -h test-atldb.esc13.net --max_allowed_packet=512M confluence | gzip -c > ~/backups/$file1.gz
        echo "WIKI database backup complete!!"
        echo ""
	return 1
 else
	echo ""
	echo "*** $datadir doesn't exist ***"
	echo ""
	return 1

 fi

}


function srvstat() {

  if [ -z $1 ]; then
     echo ""
     echo "*******************************************"
     echo "Missing parameter for the application name "
     echo "Usage: srvstat <application_name>"
     echo "Examples: srvstat jira; srvstat confluence"
     echo ""
     return 1
  fi

  if [[ $1 == "confluence" && -f $wikisite/start-confluence.sh ]]; then
    sudo tail -200 /var/atlassian/application-data/confluence/logs/atlassian-confluence.log
    return 1
  elif [[ $1 == "jira" && -f $jirasite/start-jira.sh ]]; then
    sudo tail -200 /var/atlassian/application-data/jira/log/atlassian-jira.log   
    return 1
  elif [[ $1 == "crowd" && -f $crowdsite/start_crowd.sh ]]; then
    sudo tail -200 /var/crowd-home/logs/atlassian-crowd.log  
    return 1
  else
	  echo ""
	  echo "Application $1 not found on this server: $(hostname) "
	  echo "please make sure to type de correct name."
	  echo ""
	  echo "valid names are crowd, confluence or jira"
	  echo ""
	  return 1

  fi

}

