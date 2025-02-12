#!bin/bash

# 1
OUT="work3.log"
awk -F: '{printf "user %s has id %s\n", $1, $3}' /etc/passwd > $OUT
echo >> $OUT

# 2
chage -l root | grep 'Последний раз' >> $OUT
echo >> $OUT

# 3
cut -d: -f1 /etc/group | paste -sd, >> $OUT
echo >> $OUT

# 4
echo "Be careful!" > /etc/skel/readme.txt

# 5
useradd -p 12345678 u1

# 6
groupadd g1

# 7
usermod -aG g1 u1
