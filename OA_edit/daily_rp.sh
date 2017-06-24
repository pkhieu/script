#!/bin/sh

# shellcheck disable=SC2086
#etd=$(date +%s)
# Yesterday in epcho time
eyd=$(date -d "yesterday" +%s)

# DB account and pass
user="openaudit"
pass="openauditpassword"

# report location
#now=$(date +"%Y-%m-%d")

ytd=$(date -d "yesterday" +"%Y-%m-%d")

off_rp="/root/OA_script/report/off/OA_rp_off_$ytd"
ram_rp="/root/OA_script/report/ram/OA_rp_ram_$ytd"
hdd_rp="/root/OA_script/report/hdd/OA_rp_hdd_$ytd"
vga_rp="/root/OA_script/report/vga/OA_rp_vga_$ytd"

dl_rp="/root/OA_script/report/OA_rp_dl_$ytd.csv"

# PC offline
mysql -u $user -p$pass -e "select system.id,system.hostname,system.ip from openaudit.system where UNIX_TIMESTAMP(system.last_seen)<=$eyd;" > tmpfile && mv tmpfile $off_rp
# Ram change report
mysql -u $user -p$pass -e "select system.id,system.hostname,system.ip,system.last_seen,edit_log.db_column,edit_log.value,edit_log.previous_value from openaudit.edit_log left join openaudit.system on system.id = edit_log.system_id where edit_log.db_column='memory_count' and UNIX_TIMESTAMP(edit_log.timestamp)>=0 and edit_log.previous_value=!0;"  > tmpfile && mv tmpfile $ram_rp

# HHD remove report
 mysql -u $user -p$pass -e "select system.id,system.hostname,system.ip,system.last_seen,disk.manufacturer,disk.model from openaudit.disk left join openaudit.system on system.id = disk.system_id where UNIX_TIMESTAMP(disk.last_seen)>=$eyd and disk.current = 'n';" > tmpfile && mv tmpfile $hdd_rp

# VGA remove report
 mysql -u $user -p$pass -e "select system.id,system.hostname,system.ip,system.last_seen,video.manufacturer,video.model from openaudit.video left join openaudit.system on system.id = video.system_id where UNIX_TIMESTAMP(video.last_seen)>=$eyd and video.current='n';" > tmpfile && mv tmpfile $vga_rp

# Daily Full report
mysql -u $user -p$pass -e "use openaudit;select system.id,system.hostname,system.ip,system.last_seen,system.os_name,motherboard.model,processor.description,disk.model,system.memory_count,video.model from openaudit.video right join (openaudit.disk right join (openaudit.processor right join (openaudit.system left join openaudit.motherboard on system.id=motherboard.system_id) on processor.system_id=system.id) on disk.system_id = system.id ) on video.system_id = system.id where
UNIX_TIMESTAMP(disk.last_seen)>=$eyd and disk.current='y' and video.current='y';"  > tmpfile && sed 's/\t/,/g' tmpfile > $dl_rp

# Make report
tt_rp="/root/OA_script/report/OA_rp_tt_$ytd.csv"
{
 echo "- Total PC off in $ytd is: $(awk 'NR!=1' $off_rp | wc -l )"
 cat $off_rp
 echo
 echo "- Total Ram remove in $ytd is: $(awk 'NR!=1' $ram_rp | wc -l )"
 cat $ram_rp
 echo
 echo "- Total HDD remove in $ytd is: $(awk 'NR!=1' $hdd_rp | wc -l )"
 cat $ram_rp
 echo
 echo "- Total VGA remove in $ytd is: $(awk 'NR!=1' $vga_rp | wc -l )"
 cat $ram_rp
} > $tt_rp

mutt -s "[Open-Audit] Daily Report - $ytd" -- hieu.phamkhac@gameloft.com < $tt_rp
#mutt -s "[Open-Audit]Daily Report - $ytd" -a $full_rp -- hieu.phamkhac@gameloft.com < $tt_rp
