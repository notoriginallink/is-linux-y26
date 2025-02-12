#!bin/bash

# 1
W3="work3.log"
awk -F: '{printf "user %s has id %s\n", $1, $3}' /etc/passwd > $W3
printf '\n' >> $W3

# 2
chage -l root | grep 'Последний раз' >> $W3
printf '\n' >> $W3

# 3
cut -d: -f1 /etc/group | paste -sd, >> $W3
printf '\n' >> $W3
