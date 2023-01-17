#!/bin/bash
# useradd1.sh - A simple shell script to display the form dialog on screen
# set field names i.e. shell variables

# open fd
exec 3>&1

# Store data to $VALUES variable
dialog --colors --ok-label "Create" \
	  --backtitle "\Zb\Z3Database Managment" \
	  --title "\Zb\Z1Database creation" \
	  --form "\Zb\Z2Create a new database" \
15 50 6 \
	"database:" 1 1	"" 	1 10 25 0 \
	"username:" 3 1	""  	3 10 25 0 \
	"password:" 5 1	""  	5 10 25 0 > /tmp/out.tmp \
2>&1 1>&3

# Start retrieving each line from temp file 1 by one with sed and declare variables as inputs
database=`sed -n 1p /tmp/out.tmp`
username=`sed -n 2p /tmp/out.tmp`
password=`sed -n 3p /tmp/out.tmp`

rm -f /tmp/out.tmp

# close fd

exec 3>&-

mysql -u root -e "create database "$database";"
mysql -u root -e "create user "$username"@'localhost' identified by '"$password"';"
mysql -u root -e "grant all privileges on "$database".* to "$username"@'localhost';"
mysql -u root -e "flush privileges;"
clear

echo "database: $database" > db_cred.txt
echo "username: $username" >> db_cred.txt
echo "password: $password" >> db_cred.txt

echo -e "\e[1;34m + database credentials + \e[0m"

cat db_cred.txt
