#!/bin/bash
ym=$(date +"%m-%Y")
#active report
m_a_rp="/root/OA_script/report/monthly/monthly_a_rp_$ym.csv"
#deactive report
m_d_rp="/root/OA_script/report/monthly/monthly_d_rp_$ym.csv"
# acc/pass
user="openaudit"
pass="openauditpassword"
# Monthly report
#Active devices
mysql -u $user -p$pass -e "select system.id,system.hostname,system.ip,system.os_name,system.last_seen,windows.user_name,motherboard.model,processor.description,disk.model,system.memory_count,video.model from openaudit.video right join (openaudit.disk right join (openaudit.processor right join (openaudit.motherboard right join (openaudit.system left join openaudit.windows on windows.system_id = system.id) on motherboard.system_id = system.id) on processor.system_id = system.id) on
disk.system_id=system.id) on video.system_id = system.id where disk.current='y' and video.current='y';" > tmp && sed 's/\t/,/g' tmp > $m_a_rp

#no user
#mysql -u $user -p$pass -e "select system.id,system.hostname,system.ip,system.os_name,system.last_seen,motherboard.model,processor.description,disk.model,system.memory_count,video.model from openaudit.video right join (openaudit.disk right join (openaudit.processor right join (openaudit.system left join openaudit.motherboard on system.id = motherboard.system_id) on processor.system_id = system.id) on disk.system_id = system.id ) on video.system_id = system.id where disk.current='y' and video.current='y';" > test1 && sed 's/\t/,/g' test1 > test2

#cat $m_rp
#Deactive devices
mysql -u $user -p$pass -e "select system.id,system.hostname,system.ip,system.os_name,system.last_seen,windows.user_name,motherboard.model,processor.description,disk.model,system.memory_count,video.model from openaudit.video right join (openaudit.disk right join (openaudit.processor right join (openaudit.motherboard right join (openaudit.system left join openaudit.windows on windows.system_id = system.id) on motherboard.system_id = system.id) on processor.system_id = system.id) on
disk.system_id=system.id) on video.system_id = system.id where disk.current='n' and video.current='n';" > tmp && sed 's/\t/,/g' tmp > $m_d_rp

#Total change


#no user
echo "Monthly report in $ym" | mutt -s "[Open-Audit] Monthly Report - $ym" -a $m_a_rp -a $m_d_rp -- hieu.phamkhac@gameloft.com
