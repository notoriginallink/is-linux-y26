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
useradd -m -p $(openssl passwd 12345678) u1 2>>/dev/null

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
useradd -m -p $(openssl passwd 87654321) u2 2>>/dev/null

# 13
TEST13="/home/test13"
mkdir $TEST13
cp $OUT $TEST13/work3-1.log
cp $OUT $TEST13/work3-2.log

# 14
chown -R u1:u2 $TEST13
chmod 750 $TEST13
chmod 640 $TEST13/*

# 15
TEST14="/home/test14"
mkdir $TEST14
chown -R u1:u1 $TEST14
chmod -R 1777 $TEST14

# 16
cp /bin/nano $TEST14
chown u1 $TEST14/nano
chmod 4777 $TEST14/nano # Т.е. все пользователи запускающие nano будут иметь такие же права как его владелец u1, и смогут изменять файлы в test13

# 17
TEST15="/home/test15"
touch $TEST15/secret_file
chmod 771 $TEST15 # Разрешает всем заходить в каталог, но не разрешает смотреть список файлов (так как нет чтения)
chmod 774 $TEST15/secret_file # разрешает читать секретный файл

# 18
echo "u1 ALL=(ALL) NOPASSWD: /usr/bin/passwd" >> /etc/sudoers














