#!/bin/bash
ym=$(date +"%m-%Y")
m_rp="/root/OA_script/report/monthly/monthly_rp_$ym.csv"
# acc/pass
user="openaudit"
pass="openauditpassword"
# Monthly report
mysql -u $user -p$pass -e "select system.id,system.hostname,system.ip,system.os_name,system.last_seen,windows.user_name,motherboard.model,processor.description,disk.model,system.memory_count,video.model from openaudit.video right join (openaudit.disk right join (openaudit.processor right join (openaudit.motherboard right join (openaudit.system left join openaudit.windows on windows.system_id = system.id) on motherboard.system_id = system.id) on processor.system_id = system.id) on disk.system_id=system.id) on video.system_id = system.id where disk.current='y' and video.current='y';" > tmp && sed 's/\t/,/g' tmp > $m_rp
#no user
#mysql -u $user -p$pass -e "select system.id,system.hostname,system.ip,system.os_name,system.last_seen,motherboard.model,processor.description,disk.model,system.memory_count,video.model from openaudit.video right join (openaudit.disk right join (openaudit.processor right join (openaudit.system left join openaudit.motherboard on system.id = motherboard.system_id) on processor.system_id = system.id) on disk.system_id = system.id ) on video.system_id = system.id where disk.current='y' and video.current='y';" > test1 && sed 's/\t/,/g' test1 > test2

#cat $m_rp
echo "Monthly report in $ym" | mutt -s "[Open-Audit] Monthly Report - $ym" -a $m_rp -- hieu.phamkhac@gameloft.com
