#!/bin/bash
date=$(date +"%Y-%m-%d" )
path="/root/OA_script/db_$date"
db_tables="/root/OA_script/db_tables/tables"

user="openaudit"
pass="openauditpassword"

mysql -u $user -p$pass -e "use openaudit;show tables;" > $db_tables

awk 'NR!=1' $db_tables | while read i
do
    {
    echo "$i"
    mysql -u $user -p$pass -e "use openaudit;select * from openaudit.$i"
    } >> $path
done
