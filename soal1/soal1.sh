#!/bin/bash

#1a Untuk mendapatkan jenis log, pesan log, dan username 
#grep -oP "((?<=ticky\:\ ).*)" syslog.log

#1b dan 1d 
#Untuk menampilkan semua pesan error yang muncul besserta jumlah kemunculannya
#grep -oP "((?<=ERROR\ ).*?(?=\ \())" syslog.log | sort | uniq -c

#Untuk disimpan sesuai format
printf "Error,Count\n" > error_message.csv
grep -oP '(?<=ERROR\ ).*?(?=\ \()' syslog.log | sort | uniq -c | sort -nr | while read -r line; do
count=$(grep -oP "([0-9].*?(?=\ ))" <<< "$line")
message=$(grep -oP "(?<=\d\ ).*\w" <<< "$line")
printf "%s,%d\n" "$message" "$count" >> error_message.csv
done 


#1c dan 1e
#Untuk menampilkan seluruh user yang ada
#grep -P "((?<=\().*?(?=\)))" syslog.log | sort | uniq

#untuk menampilkan error dan info untuk setiap user yang ada
printf "Username,INFO,ERROR\n" > user_statistic.csv
grep -oP "((?<=\().*?(?=\)))" syslog.log | sort | uniq | while read -r user; do
errorCount=$(grep -w "$user" syslog.log | grep "ERROR" | wc -l)
infoCount=$(grep -w "$user" syslog.log | grep "INFO" | wc -l)
printf "%s,%d,%d\n" "$user" "$infoCount" "$errorCount" >> user_statistic.csv
done