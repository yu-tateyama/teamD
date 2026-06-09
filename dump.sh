#!/bin/bash

start_time=$(date +%s)
echo $start_time > /usr/local/dump/dump.log
set PGPASSWORD=Zaq12wsx
/usr/local/postgresql/bin/pg_dump --dbname=postgresql://postgres:Zaq12wsx@localhost:5432/dash_replace -F c -f /tmp/hr_dash_`date +%Y%m%d`.dmp
#/usr/local/postgresql/bin/pg_dump --dbname=postgresql://postgres:Zaq12wsx@localhost:dash_replace -U postgres -h 127.0.0.1 dash_replace -F c -f /tmp/hr_dash_`date +%Y%m%d`.dmp
end_time=$(date +%s)
echo $end_time > /usr/local/dump/dump.log
elapsed_time=$((end_time - start_time))
echo "dumpにかかった時間: $elapsed_time 秒" > /usr/local/dump/dump.log
