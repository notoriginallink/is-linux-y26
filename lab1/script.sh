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
useradd -p 12345678 u1 2>>/dev/null

# 6
groupadd g1 2>>/dev/null

# 7
usermod -aG g1 u1

# 8
echo "$(id -un u1) $(id -u u1)" >> $OUT
id -Gn u1 >> $OUT
id -G u1 >> $OUT

echo >> $OUT

# 9
usermod -aG g1 myuser

# 10
cat /etc/group | grep '^g1:' | cut -d: -f4 >> $OUT
echo >> $OUT

# 11
usermod --shell /usr/bin/mc u1

# 12
useradd -p 87654321 u2 2>>/dev/null

# 13
OUT_DIR="/home/test13"
mkdir /home/test13
cp $OUT $OUT_DIR/work3-1.log
cp $OUT $OUT_DIR/work3-2.log

# 14

