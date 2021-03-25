#!/bin/bash

#soal 1 poin d
#printf "Error,Count\n" > error_message.csv
#grep "ERROR" syslog.log |cut -d " " -f7- | sort -n | sed "s/([^)]*)//g" | uniq -c | sort -nr | while read -r line ; do
#ind=$(echo -n $line |cut -d " " -f2-);
#val=$(echo -n $line|cut -d " " -f1);

#printf "${ind/$'\r'/'\b,'}${val}\n" >> error_message.csv
#done 

printf "ERROR,COUNT\n" > "error_message.csv" 
grep -oP '(?<=ERROR\ ).*?(?=\ \()' syslog.log | sort | uniq -c | sort -nr | grep -oP '^ *[0-9]+ \K.*'| while read -r line; do

msg=$(echo "$line")
count=$(grep "$line" syslog.log | wc -l)

printf "%s,%d\n" "$msg" "$count" >> "error_message.csv"
done 

#soal 1 poin e
nameList=($(grep 'INFO\|ERROR' syslog.log | grep -oP '(?<=\().*?(?=\))' | sort | uniq))
printf "Username,INFO,ERROR\n" > "user_statistic.csv"
for i in ${nameList[@]};
do
  user=$i;
  error=$(grep -wE "ERROR" syslog.log | grep -wE "$i" | wc -l);
  info=$(grep -wE "INFO" syslog.log | grep -wE "$i" | wc -l);
  printf "%s,%d,%d\n" "$user" "$info" "$error" >> "user_statistic.csv"
done
