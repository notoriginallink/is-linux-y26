#!bin/bash

userdel -r u1 2>>/dev/null
userdel -r u2 2>>/dev/null

groupdel g1 2>>/dev/null

rm -rf /home/test13
rm -rf /home/test14
rm -rf /home/test15
rm -f work3.log

# Самая опасная часть
STRING="u1 ALL=(ALL) NOPASSWD: /usr/bin/passwd"
FILE="/etc/sudoers"
if grep -qF "$STRING" "$FILE"; then
	sed -i "\|$STRING|d" "$FILE"
fi


echo "Deleted successfuly"
